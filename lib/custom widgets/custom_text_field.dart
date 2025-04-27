import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.labelText, this.isObscureText = false, required this.controller});
  final TextEditingController controller;
  final String labelText;
  final bool isObscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        cursorColor: Color.fromRGBO(38, 79, 33, 1),
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(149, 188, 143, 1.0), width: 2.1)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(149, 188, 143, 1.0), width: 2.1)),
            filled: true,
            fillColor: Color.fromRGBO(233, 249, 230, 1.0),
            border: OutlineInputBorder(),
            labelText: labelText),
        obscureText: isObscureText);
  }
}
