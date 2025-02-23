// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:aspirehire/features/auth/reset_password/LoginForgetPass.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';
import 'package:aspirehire/features/auth/jobseeker_register/SignUpScreenJobSeeker.dart';
import '../../home_screen/HomeScreenJobSeeker.dart';
import 'state_management/login_cubit.dart'; // Import the LoginCubit
import 'state_management/login_state.dart'; // Import the LoginState

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignUp = true;
  bool _isObscure = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              MaterialPageRoute(builder: (context) => const ChoosingRole()),
            );
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUp = true;
                        });
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: isSignUp ? const Color(0xFF013E5D) : Colors.grey,
                          fontSize: 16,
                          fontWeight: isSignUp ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.13),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUp = false;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreenJobSeeker()),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: isSignUp ? Colors.grey : const Color(0xFF013E5D),
                          fontSize: 16,
                          fontWeight: isSignUp ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ReusableComponents.reusableTextField(
                  hintText: 'Email Address',
                  hintColor: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  borderRadius: 10.0,
                  borderColor: Colors.grey,
                  controller: _usernameController, // Add controller
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ReusableComponents.reusableTextField(
                  hintText: 'Password',
                  hintColor: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  borderRadius: 10.0,
                  borderColor: Colors.grey,
                  obscureText: _isObscure,
                  controller: _passwordController, // Add controller
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginForgetPass()),
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      // Navigate to the next screen on successful login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    } else if (state is LoginFailure) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const CircularProgressIndicator();
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ReusableComponents.reusableButton(
                        title: 'Login',
                        fontSize: 18,
                        backgroundColor: const Color(0xFF013E5D),
                        textColor: Colors.white,
                        onPressed: () {
                          final username = _usernameController.text;
                          final password = _passwordController.text;
                          context.read<LoginCubit>().login(username, password);
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
    );
  }
}