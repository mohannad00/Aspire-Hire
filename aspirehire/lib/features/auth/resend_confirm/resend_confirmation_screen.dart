// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:aspirehire/features/auth/login/LoginScreen.dart';
import 'package:aspirehire/features/auth/resend_confirm/resend_confirm_cubit.dart';
import 'package:aspirehire/features/auth/resend_confirm/resend_confirm_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendConfirmationScreen extends StatefulWidget {
  const ResendConfirmationScreen({super.key});

  @override
  _ResendConfirmationScreenState createState() => _ResendConfirmationScreenState();
}

class _ResendConfirmationScreenState extends State<ResendConfirmationScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Method to show success dialog and navigate
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
            'A confirmation email has been sent. Please check your email to confirm your account.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF013E5D)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResendConfirmCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: BlocConsumer<ResendConfirmCubit, ResendConfirmState>(
          listener: (context, state) {
            if (state is ResendConfirmSuccess) {
              // Show success dialog instead of direct navigation
              _showSuccessDialog(context);
            } else if (state is ResendConfirmFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                      const Text(
                        "Resend Confirmation Email",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(7),
                        child: Text(
                          "Don’t worry, we will send you confirmation instructions.",
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
                        controller: _emailController,
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
                          title: state is ResendConfirmLoading
                              ? 'Loading...'
                              : 'Send Confirmation',
                          fontSize: 18,
                          backgroundColor: const Color(0xFF013E5D),
                          textColor: Colors.white,
                          onPressed: state is ResendConfirmLoading
                              ? () {} // Do nothing when loading
                              : () {
                                  context
                                      .read<ResendConfirmCubit>()
                                      .resendConfirmation(_emailController.text.trim());
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}