// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ReusableTextField {
  static Widget build({
    required String hintText,
    Color hintColor = Colors.grey,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.normal,
    double borderRadius = 10.0,
    Color borderColor = Colors.grey,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
