import 'dart:async';

import 'package:aspirehire/core/utils/app_text_styles.dart';
import 'package:aspirehire/features/onboarding/OnboardingScreen.dart';
import 'package:flutter/material.dart';

import '../../config/datasources/cache/shared_pref.dart';
import '../hame_nav_bar/home_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Wait for 2 seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Initialize cache helper
    await CacheHelper.init();

    // Check if token exists
    final token = CacheHelper.getData('token');

    if (!mounted) return;

    // Navigate based on token existence
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                token != null ? const HomeNavBar() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Hiro', style: CustomTextStyles.pacifico400style64),
      ),
    );
  }
}
