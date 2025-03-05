// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ReusableButton {
  static Widget build({
    required String title,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    double fontSize = 15.0,
    bool isOutlined = false,
  }) {
    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor,
              side: BorderSide(color: backgroundColor),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(fontSize: fontSize),
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(fontSize: fontSize),
            ),
          );
  }
}
