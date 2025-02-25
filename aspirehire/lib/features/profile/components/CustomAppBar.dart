import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF013E5D),
      actions: [
        IconButton(
          icon: const Icon(Icons.check, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
