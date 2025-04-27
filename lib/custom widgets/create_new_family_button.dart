import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polivalka/custom%20widgets/custom_text_field.dart';
import 'package:polivalka/util/http_util.dart';
import 'package:polivalka/util/toast_util.dart';

class CreateNewFamilyButton extends StatefulWidget {
  const CreateNewFamilyButton({super.key});

  @override
  State<CreateNewFamilyButton> createState() => _CreateNewFamilyButtonState();
}

class _CreateNewFamilyButtonState extends State<CreateNewFamilyButton> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final TextEditingController _familyNameController = TextEditingController();

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
                                icon: Icon(Icons.close),
                                color: Color.fromRGBO(38, 79, 33, 1)),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Text(
                              'Создать семью',
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Color.fromRGBO(38, 79, 33, 1)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Имя семьи'),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                                labelText: 'Введите имя семьи',
                                controller: _familyNameController)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(149, 188, 143, 1.0)),
                                onPressed: () async {
                                  var statusCode = await HttpUtil.createFamily(
                                      _familyNameController.text);
                                  if (statusCode == 201) {
                                    ToastUtil.showToast(
                                        'Новая семья успешно создана',
                                        Color.fromRGBO(82, 140, 77, 1),
                                        context);
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
                                child: Text(
                                  'Создать',
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
          'Создать новую семью',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
