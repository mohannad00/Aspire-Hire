import 'package:aspirehire/features/auth/company_register/state_management/company_register_cubit.dart';
import 'package:aspirehire/features/community/state_management/comment_cubit.dart';
import 'package:aspirehire/features/community/state_management/follower_cubit.dart';
import 'package:aspirehire/features/community/state_management/friend_cubit.dart';
import 'package:aspirehire/features/create_post/state_management/create_post_cubit.dart';
import 'package:aspirehire/features/feed/state_management/feed_cubit.dart';
import 'package:aspirehire/features/feed/state_management/like_cubit.dart';
import 'package:aspirehire/features/people_search/state_management/search_users_cubit.dart';
import 'package:aspirehire/features/seeker_profile/state_management/profile_cubit.dart';
import 'package:aspirehire/features/seeker_profile/state_management/user_profile_cubit.dart';
import 'package:aspirehire/features/skill_test/state_management/skill_test_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/splash_screen/splash_screen.dart';
import 'features/ats_evaluate/state_management/ats_evaluate_cubit.dart';
import 'features/auth/jobseeker_register/state_management/jobseeker_register_cubit.dart';
import 'features/auth/login/state_management/login_cubit.dart';
import 'features/company_feed/state_management/company_comment_cubit.dart';
import 'features/company_feed/state_management/company_feed_cubit.dart';
import 'features/company_feed/state_management/company_like_cubit.dart';
import 'features/company_profile/company_profile_cubit.dart';
import 'features/generate_summary/state_management/generate_summary_cubit.dart';
import 'features/generate_cv/state_management/generate_cv_cubit.dart';

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
        BlocProvider(create: (context) => UserProfileCubit()),
        BlocProvider(create: (context) => ATSEvaluateCubit()),
        BlocProvider(create: (context) => GenerateSummaryCubit()),
        BlocProvider(create: (context) => GenerateCvCubit()),
        BlocProvider(create: (context) => CompanyFeedCubit()),
        BlocProvider(create: (context) => CompanyCommentCubit()),
        BlocProvider(create: (context) => CompanyLikeCubit()),
        BlocProvider(create: (context) => CompanyProfileCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
