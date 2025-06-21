import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/components/ReusableButton.dart';
import '../../config/datasources/cache/shared_pref.dart';
import 'components/company_job_post_card.dart';
import 'state_management/company_job_posts_cubit.dart';
import '../job_post/PostJob.dart';

class CompanyJobPostsScreen extends StatefulWidget {
  const CompanyJobPostsScreen({super.key});

  @override
  State<CompanyJobPostsScreen> createState() => _CompanyJobPostsScreenState();
}

class _CompanyJobPostsScreenState extends State<CompanyJobPostsScreen> {
  @override
  void initState() {
    super.initState();
    _loadJobPosts();
  }

  Future<void> _loadJobPosts() async {
    try {
      final token = await CacheHelper.getData('token');
      if (token != null) {
        context.read<CompanyJobPostsCubit>().getCompanyJobPosts(token);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading job posts: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF044463),
                child: const Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'My Job Posts',
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
      body: BlocConsumer<CompanyJobPostsCubit, CompanyJobPostsState>(
        listener: (context, state) {
          if (state is CompanyJobPostsFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CompanyJobPostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CompanyJobPostsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load job posts',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ReusableButton.build(
                    title: 'Retry',
                    backgroundColor: const Color(0xFF044463),
                    textColor: Colors.white,
                    onPressed: _loadJobPosts,
                    fontSize: 16,
                  ),
                ],
              ),
            );
          }

          if (state is CompanyJobPostsSuccess) {
            if (state.jobPosts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.work_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No Job Posts Yet',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You haven\'t posted any jobs yet.\nStart by creating your first job post!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ReusableButton.build(
                      title: 'Post a Job',
                      backgroundColor: const Color(0xFF044463),
                      textColor: Colors.white,
                      onPressed: () {
                        // Navigate to post job screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PostJob(
                                  onNavigateToHome: () {
                                    // Navigate back to home tab
                                    Navigator.pop(context);
                                  },
                                ),
                          ),
                        );
                      },
                      fontSize: 16,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _loadJobPosts,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.jobPosts.length,
                itemBuilder: (context, index) {
                  final jobPost = state.jobPosts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CompanyJobPostCard(jobPost: jobPost),
                  );
                },
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
