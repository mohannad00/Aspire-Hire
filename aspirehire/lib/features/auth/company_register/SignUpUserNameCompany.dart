// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:aspirehire/features/auth/company_register/SignUpPasswordCompany.dart';
import 'package:aspirehire/features/auth/company_register/SignUpPhoneCompany.dart';
import 'package:aspirehire/features/auth/company_register/state_management/company_register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpUserNameCompany extends StatefulWidget {
  const SignUpUserNameCompany({super.key});

  @override
  _SignUpUserNameCompanyState createState() => _SignUpUserNameCompanyState();
}

class _SignUpUserNameCompanyState extends State<SignUpUserNameCompany> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSignUp = true;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Error",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isValidUsername(String username) {
    // Username should be at least 3 characters long and contain only letters, numbers, and underscores
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,}$');
    return usernameRegExp.hasMatch(username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: ReusableBackButton.build(
          context: context,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpPhoneCompany(),
              ),
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      " Company",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 216, 130, 10),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ReusableTextField.build(
                  controller: _usernameController,
                  hintText: 'Username',
                  hintColor: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  borderRadius: 10.0,
                  borderColor: Colors.grey,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (!_isValidUsername(value)) {
                      return 'Username must be at least 3 characters long and contain only letters, numbers, and underscores';
                    }
                    return null;
                  },
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
                      if (_formKey.currentState!.validate()) {
                        // Get the cubit instance
                        final cubit = context.read<CompanyRegisterCubit>();

                        // Update the username in the cubit
                        cubit.updateUsername(_usernameController.text);

                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider.value(
                                  value: cubit,
                                  child: const SignUpPasswordCompany(),
                                ),
                          ),
                        );
                      }
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
      ),
    );
  }
}
