import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/auth/login/LoginScreen.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Helper method to navigate to the LoginScreen
  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: ReusableComponents.reusableBackButton(
              context: context,
              onPressed: () {
                // Navigate to the login screen when the back button is pressed
                _navigateToLoginScreen(context);
              },
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
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
                      ReusableComponents.reusableTextField(
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
                      ReusableComponents.reusableTextField(
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
                            _isObscureconfirm ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscureconfirm = !_isObscureconfirm;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      // Next button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ReusableComponents.reusableButton(
                          title: 'Sign Up',
                          fontSize: 18,
                          backgroundColor: const Color(0xFF013E5D),
                          textColor: Colors.white,
                          onPressed: () {
                            if (_passwordController.text != _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Passwords do not match')),
                              );
                              return;
                            }

                            // Update the password in the cubit
                            context.read<JobSeekerRegisterCubit>().updatePassword(_passwordController.text);

                            // Trigger the registration process
                            context.read<JobSeekerRegisterCubit>().registerJobSeeker();
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
              // Show a loading indicator when the state is JobSeekerRegisterLoading
              if (state is JobSeekerRegisterLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF013E5D),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}