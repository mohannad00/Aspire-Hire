// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/profile.jpg'), // استبدل بالصورة الفعلية
        ),
        SizedBox(width: 10),
        Text(
          "Mustafa Mahmoud",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
