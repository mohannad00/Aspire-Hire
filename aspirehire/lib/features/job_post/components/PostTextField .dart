// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  const PostTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Write a post!",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
