import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polivalka/custom%20widgets/background_picture.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:polivalka/custom%20widgets/custom_text_field.dart';

import 'package:polivalka/util/http_util.dart';
import 'package:polivalka/util/toast_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 255, 248, 1),
      body: Stack(children: [
        BackgroundPicture(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color.fromRGBO(149, 188, 143, 1.0), width: 5),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Вход',
                        style: TextStyle(
                            color: Color.fromRGBO(38, 79, 33, 1), fontSize: 30),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Имя пользователя или email'),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomTextField(
                            labelText: 'Username/email',
                            controller: _usernameOrEmailController)),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Пароль'),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomTextField(
                            labelText: 'Password',
                            isObscureText: true,
                            controller: _passwordController)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromRGBO(149, 188, 143, 1.0)),
                        onPressed: () async {
                          int status = await HttpUtil.loginByAuthData(
                              _usernameOrEmailController.text,
                              _passwordController.text);
                          if (status == 302) {
                            Navigator.pushNamed(context, '/home');
                          } else if (status == 409) {
                            ToastUtil.showToast(
                                'Неверные имя пользователя/email или пароль',
                                Colors.redAccent,
                                context);
                          } else {
                            ToastUtil.showToast('Проблемы с сервером',
                                Colors.redAccent, context);
                          }
                        },
                        child: Text(
                          'Войти',
                          style: TextStyle(color: Colors.white),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                              onPressed: null,
                              child: const Text('Забыли пароль?')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () =>
                                {Navigator.pushNamed(context, '/registration')},
                            style: TextButton.styleFrom(
                                overlayColor: Colors.black),
                            child: Text(
                              'Нет аккаунта?',
                              style: TextStyle(
                                  color: Color.fromRGBO(38, 79, 33, 1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
