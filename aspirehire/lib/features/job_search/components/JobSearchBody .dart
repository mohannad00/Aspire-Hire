// ignore_for_file: file_names

import 'package:aspirehire/features/home_screen/components/JobCard.dart';
import 'package:aspirehire/features/job_search/components/JobSearchContainer%20.dart';
import 'package:flutter/material.dart';

class JobSearchBody extends StatelessWidget {
  const JobSearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobSearchContainer(), // Search bar and filter button
          SizedBox(height: 25),
          Text("All 100 jobs found", style: TextStyle(fontSize: 20)),
          SizedBox(height: 25),
          Row(
            children: [
              //JobCard(), // First job card
              SizedBox(width: 25),
              //JobCard(), // Second job card
            ],
          ),
        ],
      ),
    );
  }
}