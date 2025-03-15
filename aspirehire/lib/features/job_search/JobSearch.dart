// ignore_for_file: file_names

import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:aspirehire/features/job_search/components/JobSearchAppBar%20.dart';
import 'package:aspirehire/features/job_search/components/JobSearchBody%20.dart';
import 'package:flutter/material.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({super.key});

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobSearchAppBar(
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChoosingRole()),
          );
        },
      ),
      body: const JobSearchBody(), // Body of the screen
    );
  }
}
