// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ReusableBackButton {
  static Widget build({
    required BuildContext context,
    Color color = const Color.fromRGBO(1, 62, 93, 1),
    double iconSize = 24.0,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: color,
        size: iconSize,
      ),
      onPressed: onPressed ?? () {},
    );
  }
}
