import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:aspirehire/core/models/Company.dart';
import 'package:aspirehire/core/models/CreateJobPost.dart';
import 'package:aspirehire/features/company_profile/company_profile_cubit.dart';
import 'package:aspirehire/features/company_profile/company_profile_state.dart';
import 'package:aspirehire/features/job_applications/job_applications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/datasources/cache/shared_pref.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  String? _token;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await CacheHelper.getData('token');
    if (_token != null && !_isInitialized) {
      setState(() {
        _isInitialized = true;
      });
      _loadProfile();
    }
  }

  void _loadProfile() {
    if (_token != null) {
      context.read<CompanyProfileCubit>().profile(_token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: BlocBuilder<CompanyProfileCubit, CompanyProfileState>(
          builder: (context, state) {
            if (state is CompanyProfileLoading || _token == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CompanyProfileLoaded) {
              final CompanyUser company = state.data.user;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: CompanyProfileHeader(
                        avatarUrl: company.profilePicture?.secureUrl,
                        companyName: company.companyName,
                        role: company.role,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: CompanyProfileInfo(
                        companyName: company.companyName,
                        username: company.username,
                        email: company.email,
                        phone: company.phone,
                        address: company.address,
                        role: company.role,
                        profileId: company.profileId,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.work, color: AppColors.primary, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Job Posts',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  company.jobPosts.isEmpty
                      ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No job posts yet.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, idx) =>
                              CompanyJobPostCard(job: company.jobPosts[idx]),
                          childCount: company.jobPosts.length,
                        ),
                      ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              );
            } else if (state is CompanyProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Please load profile'));
          },
        ),
      ),
    );
  }
}

class CompanyProfileHeader extends StatelessWidget {
  final String? avatarUrl;
  final String companyName;
  final String role;
  const CompanyProfileHeader({
    Key? key,
    required this.avatarUrl,
    required this.companyName,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF013E5D), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundImage:
                    avatarUrl != null && avatarUrl!.isNotEmpty
                        ? NetworkImage(avatarUrl!)
                        : const AssetImage('assets/avatar.png')
                            as ImageProvider,
                child:
                    avatarUrl == null || avatarUrl!.isEmpty
                        ? const Icon(
                          Icons.business,
                          size: 48,
                          color: Colors.white,
                        )
                        : null,
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              companyName,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, color: Colors.amber, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyProfileInfo extends StatelessWidget {
  final String companyName;
  final String username;
  final String email;
  final String phone;
  final String? address;
  final String role;
  final String profileId;
  const CompanyProfileInfo({
    Key? key,
    required this.companyName,
    required this.username,
    required this.email,
    required this.phone,
    this.address,
    required this.role,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile(Icons.business, companyName, 'Company Name', theme),
            _buildInfoTile(Icons.person, username, 'Username', theme),
            _buildInfoTile(Icons.mail, email, 'Email', theme),
            _buildInfoTile(Icons.phone, phone, 'Phone', theme),
            if (address != null && address!.isNotEmpty)
              _buildInfoTile(Icons.location_on, address!, 'Address', theme),
            _buildInfoTile(Icons.verified_user, role, 'Role', theme),
            _buildInfoTile(Icons.badge, profileId, 'Profile ID', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String value,
    String label,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyJobPostCard extends StatelessWidget {
  final CompanyJobPost job;
  const CompanyJobPostCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Convert CompanyJobPost to JobPostData for navigation
        final jobPostData = JobPostData(
          companyId: job.companyId,
          jobTitle: job.jobTitle,
          jobDescription: job.jobDescription,
          jobCategory: job.jobCategory,
          jobType: job.jobType,
          jobPeriod: job.jobPeriod,
          experience: job.experience,
          salary: job.salary,
          city: job.city,
          country: job.country,
          location: job.location,
          fullAddress: job.fullAddress,
          requiredSkills: job.requiredSkills,
          applicationDeadline: DateTime.parse(job.applicationDeadline),
          archived: job.archived,
          id: job.id,
          createdAt: DateTime.parse(job.createdAt),
          updatedAt: DateTime.parse(job.updatedAt),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobApplicationsScreen(jobPost: jobPostData),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border(left: BorderSide(color: AppColors.primary, width: 5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.work, color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      job.jobTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      job.jobCategory,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${job.location}, ${job.country}',
                      style: const TextStyle(color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 18, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${job.salary} EGP',
                      style: const TextStyle(color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.timer, size: 18, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Type: ${job.jobType} | Period: ${job.jobPeriod} | Exp: ${job.experience}',
                      style: const TextStyle(color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.event, size: 18, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Deadline: ${job.applicationDeadline.split("T").first}',
                      style: const TextStyle(color: Colors.redAccent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                job.jobDescription,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    job.requiredSkills
                        .map((skill) => Chip(label: Text(skill)))
                        .toList(),
              ),
              const SizedBox(height: 8),
              // Add a subtle indicator that the card is clickable
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap to view applicants',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
