// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/features/auth/reset_password/LoginForgetPass.dart';
import 'package:aspirehire/features/auth/reset_password/LoginResetPass.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';
import 'package:flutter/material.dart';

class LoginVerifyAcc extends StatefulWidget {
  const LoginVerifyAcc({super.key});

  @override
  _LoginVerifyAccState createState() => _LoginVerifyAccState();
}

class _LoginVerifyAccState extends State<LoginVerifyAcc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ReusableComponents.reusableBackButton(
          context: context,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginForgetPass()),
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
                  'LOGO',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF013E5D),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                const Text(
                  "Verify Account",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                
                SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                const Text(
                  "Please check your email inbox and click on the provided link to reset your password. If you don't receive email, ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Click here to resend',
                    style: TextStyle(
                      color: Color(0xFF013E5D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ReusableComponents.reusableButton(
                    title: 'Verify Now',
                    fontSize: 18,
                    backgroundColor: const Color(0xFF013E5D),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginResetPass()),
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
