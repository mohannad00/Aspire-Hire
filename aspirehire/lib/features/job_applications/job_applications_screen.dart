import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/components/ReusableButton.dart';
import '../../config/datasources/cache/shared_pref.dart';
import '../../core/models/CreateJobPost.dart';
import '../../core/models/JobApplication.dart';
import 'components/application_card.dart';
import 'state_management/job_applications_cubit.dart';

class JobApplicationsScreen extends StatefulWidget {
  final JobPostData jobPost;

  const JobApplicationsScreen({super.key, required this.jobPost});

  @override
  State<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      final token = await CacheHelper.getData('token');
      if (token != null) {
        context.read<JobApplicationsCubit>().getJobApplications(
          token,
          widget.jobPost.id,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading applications: $e')));
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
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Applications',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            widget.jobPost.jobTitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<JobApplicationsCubit, JobApplicationsState>(
        listener: (context, state) {
          if (state is JobApplicationsFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is JobApplicationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JobApplicationsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load applications',
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
                    onPressed: _loadApplications,
                    fontSize: 16,
                  ),
                ],
              ),
            );
          }

          if (state is JobApplicationsSuccess) {
            if (state.applications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Empty state icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Main title
                      Text(
                        'No Applications Yet',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Job post info card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF044463).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF044463).withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Job Post Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF044463),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.jobPost.jobTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.jobPost.jobType} • ${widget.jobPost.jobPeriod} • \$${widget.jobPost.salary}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (widget.jobPost.city.isNotEmpty &&
                                widget.jobPost.country.isNotEmpty)
                              Text(
                                '${widget.jobPost.city}, ${widget.jobPost.country}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Explanatory text
                      Text(
                        'No one has applied to this job post yet.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Applications will appear here when candidates apply to your job post.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Suggestions
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.blue[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tips to get more applications:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildTip(
                              '• Make sure your job description is clear and detailed',
                            ),
                            _buildTip('• Set a competitive salary range'),
                            _buildTip(
                              '• Include all required skills and qualifications',
                            ),
                            _buildTip(
                              '• Share the job post on social media and job boards',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ReusableButton.build(
                              title: 'Refresh',
                              backgroundColor: Colors.grey[300]!,
                              textColor: Colors.grey[700]!,
                              onPressed: _loadApplications,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ReusableButton.build(
                              title: 'Edit Job Post',
                              backgroundColor: const Color(0xFF044463),
                              textColor: Colors.white,
                              onPressed: () {
                                // TODO: Navigate to edit job post screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Edit job post feature coming soon!',
                                    ),
                                  ),
                                );
                              },
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _loadApplications,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.applications.length,
                itemBuilder: (context, index) {
                  final application = state.applications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ApplicationCard(application: application),
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

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(tip, style: TextStyle(fontSize: 13, color: Colors.blue[700])),
    );
  }
}
