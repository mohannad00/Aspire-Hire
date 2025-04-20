import 'package:aspirehire/features/job_search/components/JobSearchContainer%20.dart';
import 'package:flutter/material.dart';

import '../../home_screen/components/JobCard.dart';
import 'JobCard .dart';

class JobSearchBody extends StatelessWidget {
   JobSearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
           
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobSearchContainer(), // Search bar and filter button
              const SizedBox(height: 25),
              const Text("All 100 jobs found", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 25),
              SizedBox(
                height: 215, // Set a fixed height for the scrollable row
                child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  JobSearchCard(), 
                  SizedBox(width: 20), 
                  JobSearchCard(), 
                  SizedBox(width: 20),
                  JobSearchCard(),    
                  SizedBox(width: 20),
                  JobSearchCard(),
                ],
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 215, // Set a fixed height for the scrollable row
                child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  JobSearchCard(), 
                  SizedBox(width: 20), 
                  JobSearchCard(), 
                  SizedBox(width: 20),
                  JobSearchCard(),    
                  SizedBox(width: 20),
                  JobSearchCard(),
                ],
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 215, // Set a fixed height for the scrollable row
                child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  JobSearchCard(), 
                  SizedBox(width: 20), 
                  JobSearchCard(), 
                  SizedBox(width: 20),
                  JobSearchCard(),    
                  SizedBox(width: 20),
                  JobSearchCard(),
                ],
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 215, // Set a fixed height for the scrollable row
                child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  JobSearchCard(), 
                  SizedBox(width: 20), 
                  JobSearchCard(), 
                  SizedBox(width: 20),
                  JobSearchCard(),    
                  SizedBox(width: 20),
                  JobSearchCard(),
                ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}