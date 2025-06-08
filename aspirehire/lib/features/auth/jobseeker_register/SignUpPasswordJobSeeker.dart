// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/auth/login/LoginScreen.dart';
import 'state_management/jobseeker_register_cubit.dart';
import 'state_management/jobseeker_register_state.dart';

class SignUpPasswordJobSeeker extends StatefulWidget {
  const SignUpPasswordJobSeeker({super.key});

  @override
  _SignUpPasswordJobSeekerState createState() =>
      _SignUpPasswordJobSeekerState();
}

class _SignUpPasswordJobSeekerState extends State<SignUpPasswordJobSeeker> {
  bool _isObscurePass = true;
  bool _isObscureconfirm = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Helper method to navigate to the LoginScreen
  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

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

  bool _isValidPassword(String password) {
    // Password must be at least 8 characters long and contain at least one uppercase letter,
    // one lowercase letter, one number, and one special character
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    ).hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobSeekerRegisterCubit, JobSeekerRegisterState>(
      listener: (context, state) {
        if (state is JobSeekerRegisterSuccess) {
          // Show a floating dialog on successful registration
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
                      // Navigate to the login screen
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
        } else if (state is JobSeekerRegisterFailure) {
          // Show a snack bar with the error message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: ReusableBackButton.build(
              context: context,
              onPressed: () {
                _navigateToLoginScreen(context);
              },
            ),
          ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        const Text(
                          'Hiro',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF013E5D),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        const Text(
                          "Let's get start!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
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
                              " Job Seeker",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 216, 130, 10),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
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
                              _isObscurePass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscurePass = !_isObscurePass;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (!_isValidPassword(value)) {
                              return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        ReusableTextField.build(
                          controller: _confirmPasswordController,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ReusableButton.build(
                            title: 'Sign Up',
                            fontSize: 18,
                            backgroundColor: const Color(0xFF013E5D),
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Update the password in the cubit
                                context
                                    .read<JobSeekerRegisterCubit>()
                                    .updatePassword(_passwordController.text);

                                // Trigger the registration process
                                context
                                    .read<JobSeekerRegisterCubit>()
                                    .registerJobSeeker();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Show a loading indicator when the state is JobSeekerRegisterLoading
              if (state is JobSeekerRegisterLoading)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFF013E5D)),
                ),
            ],
          ),
        );
      },
    );
  }
}
