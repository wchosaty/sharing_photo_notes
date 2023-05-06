import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComTextField extends StatelessWidget {
  late final double fontSize;
  late final String labelText;
  late bool obscureText;
  TextInputType keyboardType;

  ComTextField(
      {required this.labelText,
      this.fontSize = 18.0,
      this.obscureText = false,
        this.keyboardType = TextInputType.multiline});

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(fontSize: fontSize),
        maxLength: 30,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            label: Text(
          labelText,
          style: TextStyle(color: Colors.black54),
        )));
  }
}
