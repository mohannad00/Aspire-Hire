import 'package:aspirehire/features/auth/company_register/state_management/company_register_cubit.dart';
import 'package:aspirehire/features/community/state_management/comment_cubit.dart';
import 'package:aspirehire/features/community/state_management/follower_cubit.dart';
import 'package:aspirehire/features/community/state_management/friend_cubit.dart';
import 'package:aspirehire/features/create_post/state_management/create_post_cubit.dart';
import 'package:aspirehire/features/feed/state_management/feed_cubit.dart';
import 'package:aspirehire/features/feed/state_management/like_cubit.dart';
import 'package:aspirehire/features/people_search/state_management/search_users_cubit.dart';
import 'package:aspirehire/features/profile/state_management/profile_cubit.dart';
import 'package:aspirehire/features/skill_test/state_management/skill_test_cubit.dart';
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
        BlocProvider(create: (context) => FeedCubit()),
        BlocProvider(create: (context) => FriendCubit()),
        BlocProvider(create: (context) => FollowerCubit()),
        BlocProvider(create: (context) => SearchUsersCubit()),
        BlocProvider(create: (context) => SkillTestCubit()),
        BlocProvider(create: (context) => FeedCubit()),
        BlocProvider(create: (context) => CommentCubit()),
        BlocProvider(create: (context) => LikeCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => CreatePostCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
