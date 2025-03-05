// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:aspirehire/features/auth/login/LoginScreen.dart';
import 'package:aspirehire/features/auth/login/LoginVerifyAcc.dart';
import 'package:flutter/material.dart';

class LoginForgetPass extends StatefulWidget {
  const LoginForgetPass({super.key});

  @override
  _LoginForgetPassState createState() => _LoginForgetPassState();
}

class _LoginForgetPassState extends State<LoginForgetPass> {
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
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                // Logo and text
                const Text(
                  'Hiro',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF013E5D),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                const Text(
                  "Forget Password?",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                const Padding(
                  padding: EdgeInsets.all(7),
                  child: Text(
                    "Don’t warries, we will send you reset instructions.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ReusableTextField.build(
                  hintText: 'Enter Your Email',
                  hintColor: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  borderRadius: 10.0,
                  borderColor: Colors.grey,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ReusableButton.build(
                    title: 'Reset Password ',
                    fontSize: 18,
                    backgroundColor: const Color(0xFF013E5D),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginVerifyAcc()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
