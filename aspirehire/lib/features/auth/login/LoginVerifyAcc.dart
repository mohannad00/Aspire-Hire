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
                const Padding(
                  padding: EdgeInsets.all(7),
                  child: Text(
                    "Enter 4 digit code we have sent to youremail",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.21,
                      child: ReusableComponents.reusableTextField(
                        hintText: '',
                        hintColor: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        borderRadius: 10.0,
                        borderColor: Colors.grey,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.21,
                      child: ReusableComponents.reusableTextField(
                        hintText: '',
                        hintColor: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        borderRadius: 10.0,
                        borderColor: Colors.grey,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.21,
                      child: ReusableComponents.reusableTextField(
                        hintText: '',
                        hintColor: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        borderRadius: 10.0,
                        borderColor: Colors.grey,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.21,
                      child: ReusableComponents.reusableTextField(
                        hintText: '',
                        hintColor: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        borderRadius: 10.0,
                        borderColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                const Text(
                  "Haven’t received verification code?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Resend Code',
                    style: TextStyle(
                      color: Color(0xFF013E5D),
                      fontSize: 18,
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
