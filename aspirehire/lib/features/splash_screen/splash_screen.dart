import 'dart:async';

import 'package:aspirehire/features/onboarding/OnboardingScreen.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hiro',
          style: TextStyle(
        fontSize: 40,
        color: AppColors.primary,
        fontWeight:  FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
