// ignore_for_file: file_names

import 'package:aspirehire/features/job_post/PostJob.dart';
import 'package:flutter/material.dart';

class PostJobButton extends StatelessWidget {
  const PostJobButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PostJob()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text("Post a job!", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
      ),
    );
  }
}
