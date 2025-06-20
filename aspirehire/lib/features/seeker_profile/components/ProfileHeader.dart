import 'package:flutter/material.dart';
import '../../../core/models/UserProfile.dart';
import 'AddLinksScreen.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile user;
  final bool isCurrentUser;

  const ProfileHeader({
    Key? key,
    required this.user,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundImage:
                user.profilePicture?.secureUrl != null
                    ? NetworkImage(user.profilePicture!.secureUrl!)
                    : null,
            child:
                user.profilePicture?.secureUrl == null
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
          ),
          const SizedBox(height: 16),

          // Name and Username
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '@${user.username}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),

          // Role
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF013E5D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Basic Info Grid
          _buildInfoGrid(),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoItem(Icons.email, 'Email', user.email),
        _buildInfoItem(Icons.phone, 'Phone', user.phone),
        _buildInfoItem(Icons.cake, 'DOB', _formatDate(user.dob)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF013E5D), size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
      return '${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _launchURL(BuildContext context, String url) async {
    // Use url_launcher package for actual implementation
    // For now, just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Open: ' + url)));
  }
}
