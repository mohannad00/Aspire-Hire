import 'dart:async';

import 'package:aspirehire/core/utils/app_text_styles.dart';
import 'package:aspirehire/features/onboarding/OnboardingScreen.dart';
import 'package:flutter/material.dart';

import '../../config/datasources/cache/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      await CacheHelper.init();
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
          style: CustomTextStyles.pacifico400style64,
        ),
      ),
    );
  }
}
