import 'dart:async';

import 'package:aspirehire/core/utils/app_text_styles.dart';
import 'package:aspirehire/features/onboarding/OnboardingScreen.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
import '../../config/database/cache/shared_pref.dart';
import '../../core/utils/app_colors.dart';
>>>>>>> 60aa4b0efdcaeca15d43c21c3da49e951bdb8fc3

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()  {
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
