// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CreatePostButton extends StatelessWidget {
  const CreatePostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePost()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text("Write a post !", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
      ),
    );
  }
}
