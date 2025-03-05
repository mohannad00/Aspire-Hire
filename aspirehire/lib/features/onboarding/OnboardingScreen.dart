// ignore_for_file: file_names

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusablePageIndicator.dart';
import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:flutter/material.dart';

import 'OnboardingPage.dart';

class OnboardingScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChoosingRole()),
      );
    }
  }

  void _onBackPressed() {
    if (_currentPage > 0) {
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _onSkipPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChoosingRole()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ReusableBackButton.build(
          context: context,
          onPressed: _currentPage > 0 ? _onBackPressed : null,
        ),
        actions: [
          TextButton(
            onPressed: _onSkipPressed,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color.fromRGBO(1, 62, 93, 1),
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  OnboardingPage(
                    image: 'assets/onboarding1.png',
                    title: 'Streamline Your Journey',
                    description:
                        " Whether you're hiring or job seeking, find tailored opportunities with ease through our smart platform",
                  ),
                  OnboardingPage(
                    image: 'assets/onboarding2.png',
                    title: 'Smart Matching',
                    description:
                        'Receive customized job matches or find the perfect candidates that fit your skill set or company needs',
                  ),
                  OnboardingPage(
                    image: 'assets/onboarding3.png',
                    title: 'Transparency & Insight',
                    description:
                        'Gain insights from detailed company reviews and job data to make informed career or hiring decisions',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusablePageIndicator.build(
                      controller: _controller, count: 3),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: _currentPage == 2
                            ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )
                            : const CircleBorder(),
                        padding: _currentPage == 2
                            ? const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16)
                            : const EdgeInsets.all(16),
                        backgroundColor: const Color(0xFF013E5D),
                        elevation: 5,
                        minimumSize: _currentPage == 2
                            ? const Size(150, 60)
                            : const Size(56, 56),
                      ),
                      onPressed: _onNextPressed,
                      child: _currentPage == 2
                          ? const Text(
                              'Get Started',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            )
                          : const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
