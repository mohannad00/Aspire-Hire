// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ReusableAppBar {
  static PreferredSizeWidget build({
    required String title,
    required VoidCallback onBackPressed,
    List<Widget> actions = const [],
  }) {
    return AppBar(
      
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed,
      ),
      actions: actions,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
