import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/UserProfile.dart';
import '../../../core/models/GetProfile.dart' as profile;

class AboutTab extends StatelessWidget {
  final UserProfile user;

  const AboutTab({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skills Section
          if (user.skills.isNotEmpty) ...[
            _buildSectionTitle('Skills'),
            const SizedBox(height: 12),
            _buildSkillsSection(),
            const SizedBox(height: 24),
          ],

          // Education Section
          if (user.education.isNotEmpty) ...[
            _buildSectionTitle('Education'),
            const SizedBox(height: 12),
            ...user.education.map((edu) => _buildEducationCard(edu)),
            const SizedBox(height: 24),
          ],

          // Experience Section
          if (user.experience.isNotEmpty) ...[
            _buildSectionTitle('Experience'),
            const SizedBox(height: 12),
            ...user.experience.map((exp) => _buildExperienceCard(exp)),
            const SizedBox(height: 24),
          ],

          // Resume Section
          if (user.resume != null) ...[
            _buildSectionTitle('Resume'),
            const SizedBox(height: 12),
            _buildResumeCard(user.resume!),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF013E5D),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          user.skills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    skill.verified ? const Color(0xFF013E5D) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    skill.skill,
                    style: TextStyle(
                      color: skill.verified ? Colors.white : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (skill.verified) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.white, size: 14),
                  ],
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildEducationCard(profile.Education education) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.degree ?? 'Degree not specified',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            education.institution ?? 'Institution not specified',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (education.location != null) ...[
            const SizedBox(height: 4),
            Text(
              education.location!,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExperienceCard(profile.Experience experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            experience.title ?? 'Title not specified',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            experience.company ?? 'Company not specified',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (experience.duration != null) ...[
            const SizedBox(height: 4),
            Text(
              '${_formatDate(experience.duration!.from)} - ${_formatDate(experience.duration!.to)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResumeCard(Resume resume) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Color(0xFF013E5D), size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resume',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'PDF Document',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Open resume URL
              // You can use url_launcher package to open the URL
            },
            icon: const Icon(Icons.open_in_new, color: Color(0xFF013E5D)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Not specified';
    }
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
