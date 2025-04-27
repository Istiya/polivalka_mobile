import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polivalka/custom%20widgets/custom_image.dart';
import 'package:polivalka/custom%20widgets/custom_text_field.dart';
import 'package:polivalka/util/http_util.dart';
import 'package:polivalka/util/toast_util.dart';

class ChangeUserDataButton extends StatefulWidget {
  const ChangeUserDataButton({super.key, required this.image});

  final String image;

  @override
  State<ChangeUserDataButton> createState() => _ChangeUserDataButtonState();
}

class _ChangeUserDataButtonState extends State<ChangeUserDataButton> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(149, 188, 143, 1.0)),
      onPressed: _tooltipController.toggle,
      child: OverlayPortal(
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
                            padding:
                                const EdgeInsets.only(right: 3.0, top: 3.0),
                            child: IconButton(
                                onPressed: _tooltipController.toggle,
                                icon: Icon(Icons.close)),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Text(
                              'Изменить данные',
                              style: TextStyle(fontSize: 35, color: Color.fromRGBO(38, 79, 33, 1)),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                  child: _image == null
                                      ? CustomNetworkImage(
                                          image: widget.image,
                                          height: 80,
                                          width: 80)
                                      : Image.file(
                                          fit: BoxFit.cover,
                                          File(_image!.path),
                                          height: 80,
                                          width: 80)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(149, 188, 143, 1.0)),
                                  onPressed: getImage,
                                  child: Text(
                                    'Выберите файл',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Имя пользователя'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomTextField(
                              labelText: 'Введите новое имя пользоваттеля',
                              controller: _usernameController),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(149, 188, 143, 1.0)),
                                onPressed: () async {
                                  var statusCode =
                                      await HttpUtil.changeUserDara(
                                          _usernameController.text, _image);
                                  _tooltipController.toggle();
                                  if (statusCode == 200) {
                                    ToastUtil.showToast(
                                        'Данные успешно обновлены',
                                        Color.fromRGBO(82, 140, 77, 1),
                                        context);
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
                                child: Text(
                                  'Изменить',
                                  style: TextStyle(color: Colors.white),
                                )),
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
        child: const Text(
          'Изменить данные',
          style: TextStyle(color: Colors.white),
        ),
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
