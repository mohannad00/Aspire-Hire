// ignore_for_file: file_names

import 'package:aspirehire/features/job_search/components/JobSearchBody%20.dart';
import 'package:aspirehire/features/job_search/state_management/get_recommended_jobs/get_recommended_jobs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({super.key});

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetRecommendedJobsCubit(),
      child: Scaffold(
        backgroundColor: Colors.white, // Background color of the screen
        body: const JobSearchBody(), // Body of the screen
      ),
    );
  }
}
