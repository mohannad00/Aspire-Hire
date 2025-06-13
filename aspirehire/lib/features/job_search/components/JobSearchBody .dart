import 'package:aspirehire/features/job_search/components/JobSearchContainer%20.dart';
import 'package:aspirehire/features/job_search/state_management/get_recommended_jobs/get_recommended_jobs_cubit.dart';
import 'package:aspirehire/features/job_search/state_management/get_recommended_jobs/get_recommended_jobs_state.dart';
import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'JobCard .dart';
import 'RecommendedJobCard.dart';

class JobSearchBody extends StatefulWidget {
  const JobSearchBody({super.key});

  @override
  State<JobSearchBody> createState() => _JobSearchBodyState();
}

class _JobSearchBodyState extends State<JobSearchBody> {
  @override
  void initState() {
    super.initState();
    _loadRecommendedJobs();
  }

  Future<void> _loadRecommendedJobs() async {
    final token = await CacheHelper.getData('token');
    if (token != null) {
      context.read<GetRecommendedJobsCubit>().getRecommendedJobs(token);
    } else {
      // Handle case where token is not available
      print('Token not found in cache');
      // You might want to emit a specific state for this case
      // For now, we'll just show a message in the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: isSmallScreen ? 12.0 : 16.0,
          right: isSmallScreen ? 12.0 : 16.0,
          top: isSmallScreen ? 12.0 : 16.0,
          bottom: isSmallScreen ? 20.0 : 24.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JobSearchContainer(), // Search bar and filter button
              const SizedBox(height: 25),

              // Recommended Jobs Section
              const Text(
                "Recommended for You",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              BlocBuilder<GetRecommendedJobsCubit, GetRecommendedJobsState>(
                builder: (context, state) {
                  if (state is GetRecommendedJobsLoading) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is GetRecommendedJobsSuccess) {
                    if (state.recommendedJobs.isEmpty) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            "No recommended jobs found",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: isSmallScreen ? 0.55 : 0.6,
                                crossAxisSpacing: isSmallScreen ? 8 : 12,
                                mainAxisSpacing: isSmallScreen ? 8 : 12,
                              ),
                          itemCount: state.recommendedJobs.length,
                          itemBuilder: (context, index) {
                            final recommendedJob = state.recommendedJobs[index];
                            return RecommendedJobCard(
                              recommendedJob: recommendedJob,
                            );
                          },
                        ),
                        const SizedBox(height: 20), // Bottom spacing
                      ],
                    );
                  } else if (state is GetRecommendedJobsFailure) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Failed to load recommended jobs",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                _loadRecommendedJobs();
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is GetRecommendedJobsNoToken) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Please login to see recommended jobs",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to login screen
                                print('Navigate to login screen');
                              },
                              child: const Text("Login"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
