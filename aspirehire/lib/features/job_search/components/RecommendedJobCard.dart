import 'package:flutter/material.dart';
import '../../../../core/components/ReusableButton.dart';
import '../../../core/models/RecommendedJobPost.dart';
import '../../job_post/screens/JobPostDetailScreen.dart';
import '../../job_post/state_management/get_job_post/get_job_post_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendedJobCard extends StatelessWidget {
  final RecommendedJobData recommendedJob;

  const RecommendedJobCard({super.key, required this.recommendedJob});

  @override
  Widget build(BuildContext context) {
    final job = recommendedJob.job;
    final company = job.company.isNotEmpty ? job.company.first : null;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    // Convert match percentage string to double (remove % and convert)
    final matchPercentage =
        double.tryParse(recommendedJob.matchPercentage.replaceAll('%', '')) ??
        0.0;
    final matchPercent = matchPercentage / 100.0;

    // Determine color and font weight based on percentage
    Color getPercentageColor() {
      if (matchPercentage >= 80) {
        return Colors.green; // Excellent match
      } else if (matchPercentage >= 60) {
        return Colors.orange; // Good match
      } else if (matchPercentage >= 40) {
        return Colors.orangeAccent; // Fair match
      } else {
        return Colors.red; // Poor match
      }
    }

    String getMatchQuality() {
      if (matchPercentage >= 80) {
        return 'Excellent';
      } else if (matchPercentage >= 60) {
        return 'Good';
      } else if (matchPercentage >= 40) {
        return 'Fair';
      } else {
        return 'Poor';
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: getPercentageColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with match percentage and company logo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: getPercentageColor().withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Company logo
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[100],
                  backgroundImage:
                      company?.profilePicture.secureUrl != null
                          ? NetworkImage(company!.profilePicture.secureUrl)
                          : const AssetImage('assets/dell.png')
                              as ImageProvider,
                ),

                // Match percentage
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getPercentageColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    recommendedJob.matchPercentage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job period badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      job.jobPeriod,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Job title
                  Text(
                    job.jobTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Salary
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 16,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${job.salary} EGP",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Company name
                  Row(
                    children: [
                      Icon(Icons.business, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          company?.companyName ?? 'Unknown Company',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${job.city}, ${job.country}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Match quality indicator
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: getPercentageColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        getMatchQuality(),
                        style: TextStyle(
                          fontSize: 10,
                          color: getPercentageColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Apply button - Fixed at bottom
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider(
                                  create: (context) => GetJobPostCubit(),
                                  child: JobPostDetailScreen(jobPostId: job.id),
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF013E5D,
                        ), // Primary color
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply Now',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
