import 'package:aspirehire/features/auth/company_register/state_management/company_register_cubit.dart';
import 'package:aspirehire/features/my_applications/MyApplicationScreen.dart';
import 'package:aspirehire/features/profile/state_management/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/splash_screen/splash_screen.dart';
import 'features/auth/jobseeker_register/state_management/jobseeker_register_cubit.dart';
import 'features/auth/login/state_management/login_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => JobSeekerRegisterCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => CompanyRegisterCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
