// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:aspirehire/core/components/ReusableBackButton.dart';
import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/components/ReusableTextField.dart';
import 'package:aspirehire/core/utils/app_text_styles.dart';
import 'package:aspirehire/features/auth/resend_confirm/resend_confirmation_screen.dart';
import 'package:aspirehire/features/hame_nav_bar/home_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:aspirehire/features/auth/reset_password/forget_password_screen.dart';
import 'state_management/login_cubit.dart'; // Import the LoginCubit
import 'state_management/login_state.dart'; // Import the LoginState
import 'dart:convert';
import 'package:aspirehire/features/company_home_nav_bar/company_home_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

  Map<String, dynamic> decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    return json.decode(resp);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Fill in the login credentials
          setState(() {
            _usernameController.text = 'test@test.com';
            _passwordController.text = 'Mm123123';
          });
        },
        backgroundColor: const Color(0xFF013E5D),
        child: const Icon(Icons.login, color: Colors.white),
      ),
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    'Hiro',
                    style: CustomTextStyles.pacifico400style64.copyWith(
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ReusableTextField.build(
                    hintText: 'Email Address',
                    hintColor: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    borderRadius: 10.0,
                    borderColor: Colors.grey,
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ReusableTextField.build(
                    hintText: 'Password',
                    hintColor: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    borderRadius: 10.0,
                    borderColor: Colors.grey,
                    obscureText: _isObscure,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const ResendConfirmationScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Resend Confirmation Email?',
                              style: TextStyle(
                                color: Color(0xFF013E5D),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginForgetPass(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(
                                color: Color(0xFF013E5D),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        try {
                          final payload = decodeJwtPayload(state.token);
                          final role = payload['role'];
                          if (role == 'Company') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CompanyHomeNavBar(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeNavBar(),
                              ),
                            );
                          }
                        } catch (e) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeNavBar(),
                            ),
                          );
                        }
                      } else if (state is LoginFailure) {
                        _showErrorDialog(state.error);
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const CircularProgressIndicator();
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ReusableButton.build(
                          title: 'Login',
                          fontSize: 18,
                          backgroundColor: const Color(0xFF013E5D),
                          textColor: Colors.white,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final username = _usernameController.text;
                              final password = _passwordController.text;
                              context.read<LoginCubit>().login(
                                username,
                                password,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFF013E5D))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or login with',
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
      ),
    );
  }
}
