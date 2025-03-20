// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/core/components/ReusableAppBar.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:aspirehire/features/auth/company_register/SignUpUserNameCompany.dart';
import 'package:aspirehire/features/auth/company_register/state_management/company_register_cubit.dart';
import 'package:aspirehire/features/auth/company_register/state_management/company_register_state.dart';
import 'package:aspirehire/features/auth/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPasswordCompany extends StatefulWidget {
  const SignUpPasswordCompany({super.key});

  @override
  _SignUpPasswordCompanyState createState() => _SignUpPasswordCompanyState();
}

class _SignUpPasswordCompanyState extends State<SignUpPasswordCompany> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isSignUp = true;
  bool _isObscurePass = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyRegisterCubit, CompanyRegisterState>(
      listener: (context, state) {
        if (state is CompanyRegisterSuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text(
                  "Registration Successful",
                  style: TextStyle(
                    color: Color(0xFF013E5D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                content: const Text(
                  "Your registration was successful! Please check your email to confirm your account.",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _navigateToLoginScreen(context);
                    },
                    child: const Text(
                      "Go to Login",
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
        } else if (state is CompanyRegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: ReusableAppBar.build(
          title: "",
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpUserNameCompany(),
              ),
            );
          },
        ),
        body: BlocBuilder<CompanyRegisterCubit, CompanyRegisterState>(
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                          controller: _passwordController,
                          hintText: 'Password',
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
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          hintColor: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          borderRadius: 10.0,
                          borderColor: Colors.grey,
                          obscureText: _isObscureConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureConfirm ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureConfirm = !_isObscureConfirm;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                        // Sign Up button
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ReusableButton.build(
                            title: 'Sign Up',
                            fontSize: 18,
                            backgroundColor: const Color(0xFF013E5D),
                            textColor: Colors.white,
                            onPressed: state is CompanyRegisterLoading
                                ? () {} // Empty callback when loading
                                : () {
                                    if (_passwordController.text != _confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Passwords do not match')),
                                      );
                                      return;
                                    }

                                    // Get the cubit instance
                                    final cubit = context.read<CompanyRegisterCubit>();

                                    // Update the password in the cubit
                                    cubit.updatePassword(_passwordController.text);

                                    // Trigger the registration request
                                    cubit.registerCompany();
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
                // Show CircularProgressIndicator when loading
                if (state is CompanyRegisterLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF013E5D)),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}