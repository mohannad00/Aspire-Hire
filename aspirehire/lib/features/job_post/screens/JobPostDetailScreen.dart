import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state_management/get_job_post/get_job_post_cubit.dart';
import '../state_management/get_job_post/get_job_post_state.dart';
import '../../../config/datasources/cache/shared_pref.dart';

class JobPostDetailScreen extends StatefulWidget {
  final String jobPostId;

  const JobPostDetailScreen({super.key, required this.jobPostId});

  @override
  State<JobPostDetailScreen> createState() => _JobPostDetailScreenState();
}

class _JobPostDetailScreenState extends State<JobPostDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadJobPost();
  }

  Future<void> _loadJobPost() async {
    final token = await CacheHelper.getData('token');
    if (token != null) {
      context.read<GetJobPostCubit>().getJobPost(widget.jobPostId, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<GetJobPostCubit, GetJobPostState>(
          builder: (context, state) {
            if (state is GetJobPostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetJobPostSuccess) {
              final jobData = state.jobPost['data'][0];
              return _buildJobDetailContent(context, jobData);
            } else if (state is GetJobPostFailure) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load job details',
                        style: TextStyle(fontSize: 16, color: Colors.red[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadJobPost,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('No job details available'));
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF013E5D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Apply for this job',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetailContent(
    BuildContext context,
    Map<String, dynamic> jobData,
  ) {
    final company = jobData['company']?[0];
    final logoUrl = company?['profilePicture']?['secure_url'];
    final companyName = company?['companyName'] ?? 'Unknown Company';
    final profileId = company?['profileId'] ?? '';
    final jobTitle = jobData['jobTitle'] ?? 'Unknown Title';
    final jobCategory = jobData['jobCategory'] ?? '';
    final city = jobData['city'] ?? '';
    final country = jobData['country'] ?? '';
    final location = jobData['location'] ?? '';
    final fullAddress = jobData['fullAddress'] ?? '';
    final salary =
        jobData['salary'] != null ? '${jobData['salary']} EGP / month' : 'N/A';
    final jobPeriod = jobData['jobPeriod'] ?? 'N/A';
    final jobType = jobData['jobType'] ?? 'N/A';
    final experience = jobData['experience'] ?? 'N/A';
    final applicationDeadline = _formatDate(jobData['applicationDeadline']);
    final createdAt = _formatDate(jobData['createdAt']);
    final updatedAt = _formatDate(jobData['updatedAt']);
    final archived = jobData['archived'] == true ? 'Yes' : 'No';
    final jobId = jobData['_id'] ?? '';
    final companyId = jobData['companyId'] ?? '';
    final jobDescription = jobData['jobDescription'] ?? '';
    final requiredSkills = List<String>.from(jobData['requiredSkills'] ?? []);
    final responsibilities = jobData['responsibilities'] ?? [];
    final evaluation = jobData['evaluation'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Custom AppBar with rounded bottom
          Container(
            width: double.infinity,

            padding: const EdgeInsets.only(top: 48, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF013E5D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 4),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      logoUrl != null
                          ? NetworkImage(logoUrl)
                          : const AssetImage('assets/dell.png')
                              as ImageProvider,
                ),
                const SizedBox(height: 12),
                Text(
                  'Ends on $applicationDeadline',
                  style: TextStyle(fontSize: 14, color: Colors.grey[200]),
                ),
                Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  jobTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Info grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: [
                _infoPill(Icons.attach_money, 'Salary', salary),
                _infoPill(Icons.trending_up, 'Expertise', experience),
                _infoPill(Icons.location_on, 'Location', location),
                _infoPill(Icons.schedule, 'Experience', experience),
                _infoPill(Icons.work, 'Job Type', jobType),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Overview section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _sectionCard(
              number: 1,
              title: 'Overview',
              content: jobDescription,
            ),
          ),
          const SizedBox(height: 16),
          // Responsibilities section (if available)
          if (responsibilities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _sectionCard(
                number: 2,
                title: 'Responsibilities',
                content: responsibilities.join('\n'),
                isList: true,
              ),
            ),
          if (requiredSkills.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _sectionCard(
                number: 3,
                title: 'Required Skills',
                content: requiredSkills.join('\n'),
                isList: true,
              ),
            ),
          ],
          if (evaluation != null) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _evaluationSection(evaluation, number: 4),
            ),
          ],
          const SizedBox(height: 16),
          // Additional Details section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _sectionCard(
              number: 5,
              title: 'Additional Details',
              content: [
                'Job Category: $jobCategory',
                'Location: $location',
                'Full Address: $fullAddress',
                'City: $city',
                'Country: $country',
                'Salary: $salary',
                'Job Period: $jobPeriod',
                'Job Type: $jobType',
                'Experience: $experience',
                'Application Deadline: $applicationDeadline',
              ].join('\n'),
              isList: true,
            ),
          ),
          const SizedBox(height: 16),

          // Company Info section
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _infoPill(IconData icon, String label, String value) {
    return Container(
      width: 155,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 221, 124, 32), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required int number,
    required String title,
    required String content,
    bool isList = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF013E5D),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          isList
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    content
                        .split('\n')
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Expanded(
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              )
              : Text(
                content,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
        ],
      ),
    );
  }

  Widget _evaluationSection(
    Map<String, dynamic> evaluation, {
    required int number,
  }) {
    final matchPercentage = evaluation['match_percentage'] ?? 0;
    final missingSkills = List<String>.from(evaluation['missing_skills'] ?? []);
    final strengths = List<String>.from(evaluation['strengths'] ?? []);
    final improvements = List<String>.from(evaluation['improvements'] ?? []);

    Color matchColor;
    if (matchPercentage >= 80) {
      matchColor = Colors.green;
    } else if (matchPercentage >= 60) {
      matchColor = Colors.orange;
    } else if (matchPercentage >= 40) {
      matchColor = Colors.orangeAccent;
    } else {
      matchColor = Colors.red;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF013E5D),
              ),
              const SizedBox(width: 12),
              const Text(
                'Your Match',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: matchColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$matchPercentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (missingSkills.isNotEmpty) ...[
            const Text(
              'Missing Skills:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 4),
            ...missingSkills.map(
              (s) => Row(
                children: [
                  const Text('• ', style: TextStyle(color: Colors.red)),
                  Expanded(child: Text(s)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (strengths.isNotEmpty) ...[
            Container(
              width: double.infinity,
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Strengths:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Column(
              children:
                  strengths
                      .map(
                        (s) => ExpandableCard(
                          text: s,
                          color: Colors.green,
                          textColor: Colors.green.shade900,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (improvements.isNotEmpty) ...[
            Container(
              width: double.infinity,
              child: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Improvements:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Column(
              children:
                  improvements
                      .map(
                        (s) => ExpandableCard(
                          text: s,
                          color: Colors.blue,
                          textColor: Colors.blue.shade900,
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_monthName(date.month)} ${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}

class ExpandableCard extends StatefulWidget {
  final String text;
  final Color color;
  final Color textColor;
  const ExpandableCard({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => setState(() => expanded = !expanded),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(color: widget.textColor, fontSize: 15),
                maxLines: expanded ? null : 1,
                overflow:
                    expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down, color: widget.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
