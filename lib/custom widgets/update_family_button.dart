import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polivalka/custom%20widgets/custom_text_field.dart';
import 'package:polivalka/util/http_util.dart';
import 'package:polivalka/util/toast_util.dart';

class UpdateFamilyButton extends StatefulWidget {
  const UpdateFamilyButton({super.key});

  @override
  State<UpdateFamilyButton> createState() => _UpdateFamilyButtonState();
}

class _UpdateFamilyButtonState extends State<UpdateFamilyButton> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isChecked = false;

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
                              'Присоединиться к семье',
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Color.fromRGBO(38, 79, 33, 1)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Имя пользователя'),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                                labelText: 'Введите имя пользователя',
                                controller: _usernameController)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                  checkColor: Colors.white,
                                  activeColor:
                                      Color.fromRGBO(149, 188, 143, 1.0),
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  }),
                              Text('Перенести растения')
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(149, 188, 143, 1.0)),
                                onPressed: () async {
                                  var statusCode = await HttpUtil.updateFamily(
                                      _usernameController.text, _isChecked);
                                  if (statusCode == 200) {
                                    ToastUtil.showToast(
                                        'Запрос успешно отправлен',
                                        Color.fromRGBO(82, 140, 77, 1),
                                        context);
                                    _tooltipController.toggle();
                                  } else if (statusCode == 409) {
                                    ToastUtil.showToast(
                                        'Некорректно введенные данные',
                                        Colors.redAccent,
                                        context);
                                  } else if (statusCode == 400) {
                                    ToastUtil.showToast(
                                        'Пользователь не найден',
                                        Colors.redAccent,
                                        context);
                                  } else {
                                    ToastUtil.showToast('Ошибка сервера',
                                        Colors.redAccent, context);
                                  }
                                },
                                child: Text(
                                  'Отправить запрос',
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
          'Присоединиться к семье',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
