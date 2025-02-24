// ignore_for_file: file_names

import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:aspirehire/features/home_screen/HomeScreenJobSeeker.dart';
import 'package:aspirehire/features/job_search/components/JobSearchAppBar%20.dart';
import 'package:aspirehire/features/job_search/components/JobSearchBody%20.dart';
import 'package:aspirehire/features/job_search/components/JobSearchBottomNavBar%20.dart';
import 'package:aspirehire/features/profile/ProfileScreen.dart';
import 'package:flutter/material.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({super.key});

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  int _selectedIndex = 1; 

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreenJobSeeker()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      // Update the selected index
      setState(() {
        _selectedIndex = index;
      });
    }
  }

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
      bottomNavigationBar: JobSearchBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}