// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:aspirehire/features/auth/jobseeker_register/SignUpEmailJobSeeker.dart';

import 'state_management/jobseeker_register_cubit.dart'; // Import the cubit

class SignUpScreenJobSeeker extends StatefulWidget {
  const SignUpScreenJobSeeker({super.key});

  @override
  _SignUpScreenJobSeekerState createState() => _SignUpScreenJobSeekerState();
}

class _SignUpScreenJobSeekerState extends State<SignUpScreenJobSeeker> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              MaterialPageRoute(builder: (context) => const ChoosingRole()),
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
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: ReusableTextField.build(
                        controller: _firstNameController,
                        hintText: 'First Name',
                        hintColor: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        borderRadius: 10.0,
                        borderColor: Colors.grey,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Expanded(
                      child: ReusableTextField.build(
                        controller: _lastNameController,
                        hintText: 'Last Name',
                        hintColor: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        borderRadius: 10.0,
                        borderColor: Colors.grey,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                        final cubit = context.read<JobSeekerRegisterCubit>();

                        // Update the cubit with the first name and last name
                        cubit.updateFirstName(_firstNameController.text);
                        cubit.updateLastName(_lastNameController.text);

                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider.value(
                                  value: cubit,
                                  child: const SignUpEmailJobSeeker(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
