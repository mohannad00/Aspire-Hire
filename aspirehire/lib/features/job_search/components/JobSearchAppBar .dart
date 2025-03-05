import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:flutter/material.dart';

class JobSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const JobSearchAppBar({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: ReusableBackButton.build(
        context: context,
        onPressed: onBackPressed,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
