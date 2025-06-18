import 'package:flutter/material.dart';
import '../../../core/models/Application.dart';
import '../../../core/models/JobPost.dart';
import '../../../core/models/Company.dart';

class ApplicationCard extends StatelessWidget {
  final Application application;
  const ApplicationCard({Key? key, required this.application})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final company =
        application.jobPost.company.isNotEmpty
            ? application.jobPost.company.first
            : null;
    final logoUrl = company?.profilePicture?.secureUrl;
    final companyName = company?.companyName ?? '';
    final jobTitle = application.jobPost.jobTitle;
    final status = application.status;
    final dateApplied = application.createdAt;
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: width * 0.035,
          horizontal: width * 0.04,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: width * 0.075,
                  backgroundImage:
                      logoUrl != null ? NetworkImage(logoUrl) : null,
                  child:
                      logoUrl == null
                          ? const Icon(Icons.business, size: 28)
                          : null,
                  backgroundColor: Colors.grey[100],
                ),
                SizedBox(height: width * 0.03),
                Text(
                  companyName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.044,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: width * 0.008),
                Text(
                  jobTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: width * 0.037,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: width * 0.03),
                Text(
                  'Date Applied',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB0B0B0),
                    fontWeight: FontWeight.w500,
                    fontSize: width * 0.034,
                  ),
                ),
                SizedBox(height: width * 0.008),
                Text(
                  _formatDate(dateApplied),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF42526E),
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.039,
                  ),
                ),
                SizedBox(height: width * 0.02),
                Row(
                  children: [const Spacer(), _buildStatusBadge(status, width)],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.more_horiz,
                color: Colors.black54,
                size: width * 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, double width) {
    Color color;
    String label = status;
    switch (status) {
      case 'Accepted':
        color = Colors.green;
        label = 'Accepted';
        break;
      case 'Pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'Rejected':
        color = Colors.red;
        label = 'Rejected';
        break;
      default:
        color = const Color.fromARGB(255, 183, 206, 193);
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.032,
        vertical: width * 0.014,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        border: Border.all(color: color, width: 1.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width * 0.021,
            height: width * 0.021,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: width * 0.016),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: width * 0.034,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}
