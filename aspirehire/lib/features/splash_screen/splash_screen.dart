import 'dart:async';
import 'dart:convert';

import 'package:aspirehire/core/utils/app_text_styles.dart';
import 'package:aspirehire/features/onboarding/OnboardingScreen.dart';
import 'package:flutter/material.dart';

import '../../config/datasources/cache/shared_pref.dart';
import '../hame_nav_bar/home_nav_bar.dart';
import '../company_home_nav_bar/company_home_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation
    _animationController.forward();

    // Initialize and navigate
    _initializeAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, dynamic> decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    return json.decode(resp);
  }

  Future<void> _initializeAndNavigate() async {
    // Reduced delay for better UX
    await Future.delayed(const Duration(milliseconds: 1500));

    // Initialize cache helper
    await CacheHelper.init();

    // Check if token exists
    final token = CacheHelper.getData('token');

    if (!mounted) return;

    if (token != null) {
      try {
        final payload = decodeJwtPayload(token);
        final role = payload['role'];
        if (role == 'Company') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CompanyHomeNavBar()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeNavBar()),
          );
        }
      } catch (e) {
        // If decoding fails, fallback to onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text('Hiro', style: CustomTextStyles.pacifico400style64),
        ),
      ),
    );
  }
}
