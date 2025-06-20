import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/avatar.png'),
        ),
        GestureDetector(
          onTap: () {
            // أضيفي هنا وظيفة لتحميل صورة جديدة
          },
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/prime_camera.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }
}
