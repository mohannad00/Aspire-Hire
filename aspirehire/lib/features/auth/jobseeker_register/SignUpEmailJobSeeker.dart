// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/auth/login/LoginScreen.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';
import 'package:aspirehire/features/auth/jobseeker_register/SignUpPhoneJobSeeker.dart';
import 'package:aspirehire/features/auth/jobseeker_register/SignUpScreenJobSeeker.dart';

import 'state_management/jobseeker_register_cubit.dart'; // Import the cubit

class SignUpEmailJobSeeker extends StatefulWidget {
  const SignUpEmailJobSeeker({super.key});

  @override
  _SignUpEmailJobSeekerState createState() => _SignUpEmailJobSeekerState();
}

class _SignUpEmailJobSeekerState extends State<SignUpEmailJobSeeker> {
  bool isSignUp = true;
  final TextEditingController _emailController = TextEditingController();

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
              MaterialPageRoute(
                  builder: (context) => const SignUpScreenJobSeeker()),
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
                'LOGO',
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
                    " Job Seeker",
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
                    child: ReusableComponents.reusableTextField(
                      controller: _emailController, // Add controller
                      hintText: 'Email Address',
                      hintColor: Colors.grey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      borderRadius: 10.0,
                      borderColor: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              // Next button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ReusableComponents.reusableButton(
                  title: 'Next',
                  fontSize: 18,
                  backgroundColor: const Color(0xFF013E5D),
                  textColor: Colors.white,
                  onPressed: () {
                    // Get the cubit instance
                    final cubit = context.read<JobSeekerRegisterCubit>();

                    // Update the cubit with the email
                    cubit.updateEmail(_emailController.text);

                    // Navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cubit, // Pass the existing cubit
                          child: const SignUpPhoneJobSeeker(),
                        ),
                      ),
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