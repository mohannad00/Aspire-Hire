// ignore_for_file: file_names

import 'package:aspirehire/features/job_search/components/JobSearchBody%20.dart';
import 'package:aspirehire/features/job_search/state_management/get_recommended_jobs/get_recommended_jobs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/app_colors.dart';

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
        appBar : PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color:  AppColors.primary,
                  child: const Row(
                    children: [
                       Expanded(
                        child: Center(
                          child: Text(
                            'Recommended Jobs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white, // Background color of the screen
        body: const JobSearchBody(), // Body of the screen
      ),
    );
  }
}
