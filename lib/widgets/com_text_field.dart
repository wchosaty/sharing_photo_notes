import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComTextField extends StatelessWidget {
  late final double fontSize;
  late final String labelText;
  late bool obscureText;
  TextInputType keyboardType;
  late TextEditingController controller;
  late final int maxLength;

  ComTextField({
    required this.labelText,
    this.fontSize = 18.0,
    this.obscureText = false,
    this.keyboardType = TextInputType.multiline,
    required this.controller,
    this.maxLength  = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(fontSize: fontSize),
        maxLength:
        maxLength != 0 ? maxLength : 30 ,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
            label: Text(
          labelText,
          style: TextStyle(color: Colors.black54),
        )));
  }
}
