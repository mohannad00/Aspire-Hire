// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:aspirehire/features/auth/login/LoginScreen.dart';
import 'package:aspirehire/features/auth/employee_register/SignUpPasswordEmployee.dart';
import 'package:aspirehire/features/auth/employee_register/SignUpPhoneEmployee.dart';
import 'package:flutter/material.dart';

class SignUpUserNameEmployee extends StatefulWidget {
  const SignUpUserNameEmployee({super.key});

  @override
  _SignUpUserNameEmployeeState createState() => _SignUpUserNameEmployeeState();
}

class _SignUpUserNameEmployeeState extends State<SignUpUserNameEmployee> {
  bool isSignUp = true;

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
              MaterialPageRoute(
                  builder: (context) => const SignUpPhoneEmployee()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              const Text(
                "Let's get start!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign Up as",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                  Text(
                    " Employee",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 216, 130, 10),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignUp = false;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: isSignUp ? Colors.grey : const Color(0xFF013E5D),
                        fontSize: 16,
                        fontWeight:
                            isSignUp ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.13),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignUp = true;
                      });
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: isSignUp ? const Color(0xFF013E5D) : Colors.grey,
                        fontSize: 16,
                        fontWeight:
                            isSignUp ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                children: [
                  Expanded(
                      child: ReusableTextField.build(
                    hintText: 'Username',
                    hintColor: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    borderRadius: 10.0,
                    borderColor: Colors.grey,
                  )),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              // Next button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ReusableButton.build(
                  title: 'Next',
                  fontSize: 18,
                  backgroundColor: const Color(0xFF013E5D),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPasswordEmployee()),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFF013E5D))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or sign up with',
                      style: TextStyle(
                        color: Color(0xFF013E5D),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFF013E5D))),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: const Text(
                          "Feature Not Available",
                          style: TextStyle(
                            color: Color(0xFF013E5D),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        content: const Text(
                          "The Google Sign-Up feature has not been implemented yet. Stay tuned for updates!",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                color: Color(0xFF013E5D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Image.asset(
                  'assets/Google.png',
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
