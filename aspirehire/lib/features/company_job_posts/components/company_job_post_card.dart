import 'package:flutter/material.dart';
import '../../../core/models/CreateJobPost.dart';
import '../../job_applications/job_applications_screen.dart';

class CompanyJobPostCard extends StatelessWidget {
  final JobPostData jobPost;
  final VoidCallback? onTap;

  const CompanyJobPostCard({super.key, required this.jobPost, this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap:
            onTap ??
            () {
              // Navigate to job applications screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobApplicationsScreen(jobPost: jobPost),
                ),
              );
            },
        child: Container(
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
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with job title and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        jobPost.jobTitle.isNotEmpty
                            ? jobPost.jobTitle
                            : 'Untitled Job',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF044463),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            jobPost.archived
                                ? Colors.red.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        jobPost.archived ? 'Archived' : 'Active',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: jobPost.archived ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Job details
                if (jobPost.jobCategory.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.category, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          jobPost.jobCategory,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],

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
                      "\$${jobPost.salary}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        jobPost.city.isNotEmpty && jobPost.country.isNotEmpty
                            ? "${jobPost.city}, ${jobPost.country}"
                            : jobPost.fullAddress ?? "Location not specified",
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Job type and period
                Row(
                  children: [
                    Icon(Icons.work, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      "${jobPost.jobType} • ${jobPost.jobPeriod}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Skills
                if (jobPost.requiredSkills.isNotEmpty) ...[
                  Text(
                    'Required Skills:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children:
                        jobPost.requiredSkills.take(3).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF044463).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF044463),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  if (jobPost.requiredSkills.length > 3) ...[
                    const SizedBox(height: 4),
                    Text(
                      '+${jobPost.requiredSkills.length - 3} more',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],

                // Footer with date and applications count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Posted: ${_formatDate(jobPost.createdAt)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    Row(
                      children: [
                        Icon(Icons.people, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'View Applications',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF044463),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: const Color(0xFF044463),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
