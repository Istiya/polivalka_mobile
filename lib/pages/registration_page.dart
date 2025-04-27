import 'package:flutter/material.dart';
import 'package:polivalka/custom%20widgets/background_picture.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:polivalka/custom%20widgets/custom_text_field.dart';

import 'package:polivalka/util/http_util.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Invalid data"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 255, 248, 1),
      body: Stack(children: [
        BackgroundPicture(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              constraints: BoxConstraints.loose(Size(500, double.maxFinite)),
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
                          'Регистрация',
                          style: TextStyle(
                              color: Color.fromRGBO(38, 79, 33, 1),
                              fontSize: 30),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Имя пользователя'),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomTextField(
                              labelText: 'Username',
                              controller: usernameController)),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Email'),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomTextField(
                              labelText: 'Email',
                              controller: emailController)),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Пароль'),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomTextField(
                              labelText: 'Password',
                              isObscureText: true,
                              controller: passwordController)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(149, 188, 143, 1.0)),
                            onPressed: () async {
                              int status = await HttpUtil.registration(
                                  usernameController.text,
                                  emailController.text,
                                  passwordController.text);
                              if (status == 302) {
                                Navigator.pushNamed(context, '/home');
                              } else if (status == 409) {
                                _showToast();
                              } else {
                                // Server problems
                              }
                            },
                            child: Text(
                              'Зарегистрироваться',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
