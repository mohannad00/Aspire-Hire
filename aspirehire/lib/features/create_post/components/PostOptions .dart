// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PostOptions extends StatelessWidget {
  const PostOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOption(Icons.photo, "Photo"),
        _buildOption(Icons.video_collection, "Video"),
        _buildOption(Icons.insert_drive_file, "Document"),
      ],
    );
  }

  Widget _buildOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(label),
      onTap: () {
        // إضافة وظيفة الاختيار هنا
      },
    );
  }
}
