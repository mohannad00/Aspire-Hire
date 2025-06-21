import 'package:flutter/material.dart';
import '../../../core/models/JobApplication.dart';
import '../../../core/utils/cv_preview_service.dart';
import '../screens/application_details_screen.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onTap;

  const ApplicationCard({super.key, required this.application, this.onTap});

  @override
  Widget build(BuildContext context) {
    final employee = application.employee.firstOrNull;
    final firstName = employee?.firstName ?? 'Unknown';
    final lastName = employee?.lastName ?? 'User';
    final fullName = '$firstName $lastName';
    final profilePicture = employee?.profilePicture?.secureUrl;

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ApplicationDetailsScreen(
                      applicationId: application.id,
                      jobPostId: application.jobPost.id,
                    ),
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
              // Header with profile picture, name, and status
              Row(
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        profilePicture != null
                            ? NetworkImage(profilePicture)
                            : null,
                    child:
                        profilePicture == null
                            ? Text(
                              fullName.isNotEmpty
                                  ? fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  // Name and date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF044463),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Applied ${_formatDate(application.createdAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        application.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      application.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(application.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Cover letter preview
              if (application.coverLetter.isNotEmpty) ...[
                Text(
                  'Cover Letter:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  application.coverLetter.length > 150
                      ? '${application.coverLetter.substring(0, 150)}...'
                      : application.coverLetter,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Footer with resume download and view details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Resume download button
                  if (application.resume.secureUrl.isNotEmpty)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Use the CV preview service (PDF first, then WebView fallback)
                          CvPreviewService.previewCv(
                            context: context,
                            cvUrl: application.resume.secureUrl,
                            fileName: 'Resume.pdf',
                          );
                        },
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Preview Resume'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF044463),
                          side: const BorderSide(color: Color(0xFF044463)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  if (application.resume.secureUrl.isNotEmpty)
                    const SizedBox(width: 12),
                  // View details button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          onTap ??
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ApplicationDetailsScreen(
                                      applicationId: application.id,
                                      jobPostId: application.jobPost.id,
                                    ),
                              ),
                            );
                          },
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF044463),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'under review':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
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
