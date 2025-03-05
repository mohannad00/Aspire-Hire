// ignore_for_file: file_names, sort_child_properties_last, prefer_const_constructors, prefer_final_fields

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/features/onboarding/OnboardingScreen.dart';
import 'package:aspirehire/features/auth/company_register/SignUpScreenCompany.dart';
import 'package:aspirehire/features/auth/employee_register/SignUpScreenEmployee.dart';
import 'package:aspirehire/features/auth/jobseeker_register/SignUpScreenJobSeeker.dart';
import 'package:flutter/material.dart';
import 'package:aspirehire/features/auth/login/LoginScreen.dart';

class ChoosingRole extends StatefulWidget {
  const ChoosingRole({super.key});

  @override
  State<ChoosingRole> createState() => _ChoosingRoleState();
}

class _ChoosingRoleState extends State<ChoosingRole> {
  bool isUser = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ReusableBackButton.build(
          context: context,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Choose Your Role",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreenJobSeeker()),
                );
                setState(() {
                  isUser = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xffB3C5CE),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/User.png"),
                        const SizedBox(height: 20),
                        const Text(
                          "Job Seeker",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(width: 45),
                    Expanded(
                      child: const Text(
                        "Discover your dream job with detailed company insights. Make empowered career choices",
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4D4949),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreenEmployee()),
                );
                setState(() {
                  isUser = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xffB3C5CE),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/Manager.png"),
                        const SizedBox(height: 20),
                        const Text(
                          "Employee",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(width: 65),
                    Expanded(
                      child: const Text(
                        "Access valuable insights to enhance your hiring process. Find the right candidates for your team",
                        maxLines: 6,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4D4949),
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreenCompany()),
                );
                setState(() {
                  isUser = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xffB3C5CE),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/hugeicons_building-03.png"),
                        const SizedBox(height: 20),
                        const Text(
                          "Company",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(width: 65),
                    Expanded(
                      child: Text(
                        "Post job openings, find top candidates, and manage applications effortlessly to build your dream team",
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4D4949),
                          //gray-color #4D4949 rgba(77, 73, 73, 1)
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already Have an Account?"),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF013E5D),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Navigator.pushReplacement(
                      //context,
                     // MaterialPageRoute(
                        //  builder: (context) => const LoginScreen()),
                  //  );