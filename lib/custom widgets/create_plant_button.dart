import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polivalka/custom%20widgets/custom_image.dart';
import 'package:polivalka/custom%20widgets/image_radio.dart';

import '../util/http_util.dart';
import '../util/toast_util.dart';
import 'custom_text_field.dart';

class CreatePlantButton extends StatefulWidget {
  const CreatePlantButton({super.key});

  @override
  State<CreatePlantButton> createState() => _CreatePlantButton();
}

class _CreatePlantButton extends State<CreatePlantButton> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final TextEditingController _plantNameController = TextEditingController();
  int _selectedOption = 1;
  int _selectedImage = 1;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final List<String> _defaultImages = [
    'default_1.svg',
    'default_2.svg',
    'default_3.svg',
    'default_4.svg'
  ];

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _tooltipController,
      overlayChildBuilder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.75)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Color.fromARGB(255, 222, 238, 219),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3.0, top: 3.0),
                          child: IconButton(
                              onPressed: _tooltipController.toggle,
                              icon: Icon(Icons.close),
                              color: Color.fromRGBO(38, 79, 33, 1)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0),
                          child: Text(
                            'Добавить растение',
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Название'),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomTextField(
                              labelText: 'Например, "Черри"',
                              controller: _plantNameController)),
                      Column(
                        children: [
                          ListTile(
                            minTileHeight: 5,
                            minVerticalPadding: 3,
                            leading: Radio(
                              value: 1,
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value!;
                                });
                              },
                            ),
                            title: Text('Дефолтная'),
                          ),
                          ListTile(
                            minTileHeight: 5,
                            minVerticalPadding: 3,
                            leading: Radio(
                              value: 2,
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value!;
                                });
                              },
                            ),
                            title: Text('Загрузить'),
                          ),
                          _selectedOption == 1
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ImageRadio(
                                        image:
                                            'http://polivalka.ddns.net/img/default-img/default_1.svg',
                                        index: 1,
                                        onPressed: () => setState(() {
                                          _selectedImage = 1;
                                        }),
                                        selectedIndex: _selectedImage,
                                      ),
                                      ImageRadio(
                                        image:
                                            'http://polivalka.ddns.net/img/default-img/default_2.svg',
                                        index: 2,
                                        onPressed: () => setState(() {
                                          _selectedImage = 2;
                                        }),
                                        selectedIndex: _selectedImage,
                                      ),
                                      ImageRadio(
                                        image:
                                            'http://polivalka.ddns.net/img/default-img/default_3.svg',
                                        index: 3,
                                        onPressed: () => setState(() {
                                          _selectedImage = 3;
                                        }),
                                        selectedIndex: _selectedImage,
                                      ),
                                      ImageRadio(
                                        image:
                                            'http://polivalka.ddns.net/img/default-img/default_4.svg',
                                        index: 4,
                                        onPressed: () => setState(() {
                                          _selectedImage = 4;
                                        }),
                                        selectedIndex: _selectedImage,
                                      ),
                                    ],
                                  ),
                                )
                              : Row(

                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (_image != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                            fit: BoxFit.cover,
                                            File(_image!.path),
                                            height: 80,
                                            width: 80),
                                      ),
                                    ElevatedButton(
                                        onPressed: getImage,
                                        child: Text('Выбрать изображение')),
                                  ],
                                ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                int statusCode;
                                if (_selectedOption == 1) {
                                  statusCode = await HttpUtil.createPlant(
                                      _plantNameController.text,
                                      defaultImage:
                                          _defaultImages[_selectedImage]);
                                } else {
                                  statusCode = await HttpUtil.createPlant(
                                      _plantNameController.text,
                                      image: _image,
                                      defaultImage:
                                          _defaultImages[_selectedImage]);
                                }
                                if (statusCode == 201) {
                                  ToastUtil.showToast(
                                      'Новое растение успешно добавлено',
                                      Color.fromRGBO(82, 140, 77, 1),
                                      context);
                                  _image = null;
                                  _tooltipController.toggle();
                                } else if (statusCode == 409) {
                                  ToastUtil.showToast(
                                      'Некорректно введенные данные',
                                      Colors.redAccent,
                                      context);
                                } else {
                                  ToastUtil.showToast('Ошибка сервера',
                                      Colors.redAccent, context);
                                }
                              },
                              child: Text('Добавить')),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: _tooltipController.toggle,
      ),
    );
  }

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}
