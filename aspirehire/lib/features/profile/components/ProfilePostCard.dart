import 'package:flutter/material.dart';
import '../../../core/models/Feed.dart';
import '../../profile/screens/UserProfileScreen.dart';

class ProfilePostCard extends StatefulWidget {
  final Post post;

  const ProfilePostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<ProfilePostCard> createState() => _ProfilePostCardState();
}

class _ProfilePostCardState extends State<ProfilePostCard> {
  bool _isExpanded = false;
  static const int _maxLines = 6;

  @override
  Widget build(BuildContext context) {
    final publisher =
        widget.post.publisher?.isNotEmpty == true
            ? widget.post.publisher!.first
            : null;
    final profilePic = publisher?.profilePicture?.secureUrl;
    final name =
        publisher != null
            ? (publisher.firstName ?? '') + ' ' + (publisher.lastName ?? '')
            : 'Unknown';
    final username = publisher?.username ?? '';
    final content = widget.post.content ?? '';
    final attachments = widget.post.attachments ?? [];
    final createdAt =
        widget.post.createdAt != null
            ? DateTime.tryParse(widget.post.createdAt!)
            : null;

    // Check if text needs expansion
    final textSpan = TextSpan(
      text: content,
      style: const TextStyle(fontSize: 15),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: _maxLines,
    );
    textPainter.layout(
      maxWidth: MediaQuery.of(context).size.width - 40,
    ); // Account for padding
    final needsExpansion = textPainter.didExceedMaxLines;

    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.grey.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with profile info
            Row(
              children: [
                GestureDetector(
                  onTap: () => _navigateToUserProfile(publisher),
                  child: CircleAvatar(
                    backgroundImage:
                        profilePic != null ? NetworkImage(profilePic) : null,
                    child: profilePic == null ? const Icon(Icons.person) : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToUserProfile(publisher),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF013E5D),
                          ),
                        ),
                        Text(
                          '@$username',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        if (createdAt != null)
                          Text(
                            '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Content text with expand/collapse functionality
            if (content.isNotEmpty) ...[
              Text(
                content,
                style: const TextStyle(fontSize: 15),
                maxLines: _isExpanded ? null : _maxLines,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
              ),
              if (needsExpansion) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'See less' : 'See more',
                    style: const TextStyle(
                      color: Color(0xFF013E5D),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],

            // Attachments section
            if (attachments.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildAttachmentsSection(attachments),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToUserProfile(Publisher? publisher) {
    if (publisher?.profileId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => UserProfileScreen(
                userId: publisher!.profileId!,
                userName:
                    '${publisher.firstName ?? ''} ${publisher.lastName ?? ''}'
                        .trim(),
              ),
        ),
      );
    }
  }

  Widget _buildAttachmentsSection(List<Attachment> attachments) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    // Handle different attachment types
    if (attachments.length == 1) {
      final attachment = attachments.first;
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          attachment.secureUrl ?? '',
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.grey),
            );
          },
        ),
      );
    }

    // For multiple attachments, show a grid
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final attachment = attachments[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            attachment.secureUrl ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error, color: Colors.grey),
              );
            },
          ),
        );
      },
    );
  }
}
