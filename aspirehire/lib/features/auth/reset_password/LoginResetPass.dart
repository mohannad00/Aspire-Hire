// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:aspirehire/features/auth/reset_password/LoginVerifyAcc.dart';
import 'package:flutter/material.dart';

class LoginResetPass extends StatefulWidget {
  const LoginResetPass({super.key});

  @override
  _LoginResetPassState createState() => _LoginResetPassState();
}

class _LoginResetPassState extends State<LoginResetPass> {
  bool _isObscurePass = true;
  bool _isObscureconfirm = true;
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
              MaterialPageRoute(builder: (context) => const LoginVerifyAcc()),
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                const Text(
                  "Reset Your Password",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ReusableTextField.build(
                  hintText: 'New Password',
                  hintColor: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  borderRadius: 10.0,
                  borderColor: Colors.grey,
                  obscureText: _isObscurePass,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscurePass ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscurePass = !_isObscurePass;
                      });
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ReusableTextField.build(
                  hintText: 'Confirm Password',
                  hintColor: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  borderRadius: 10.0,
                  borderColor: Colors.grey,
                  obscureText: _isObscureconfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureconfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureconfirm = !_isObscureconfirm;
                      });
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // Next button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ReusableButton.build(
                    title: 'Reset Password',
                    fontSize: 18,
                    backgroundColor: const Color(0xFF013E5D),
                    textColor: Colors.white,
                    onPressed: () {},
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
