import 'package:aspirehire/features/profile/state_management/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/splash_screen/splash_screen.dart';

import 'features/auth/jobseeker_register/state_management/jobseeker_register_cubit.dart';
import 'features/auth/login/state_management/login_cubit.dart';
import 'features/job_application/JobApply.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide all your cubits here
        BlocProvider(
          create: (context) => JobSeekerRegisterCubit(),
        ), // Registration cubit
        BlocProvider(create: (context) => LoginCubit()),

        BlocProvider(create: (context) => ProfileCubit()),
        // Login cubit
        // Add more cubits here as needed
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
