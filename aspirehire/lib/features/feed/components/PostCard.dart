import 'package:flutter/material.dart';
import '../../../core/models/Feed.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  const PostCard({
    Key? key,
    required this.post,
    this.onLike,
    this.onComment,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
                CircleAvatar(
                  backgroundImage:
                      profilePic != null ? NetworkImage(profilePic) : null,
                  child: profilePic == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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

            const SizedBox(height: 10),

            // Action buttons
            Row(
              children: [
                IconButton(
                  onPressed: widget.onLike,
                  icon: Icon(
                    Icons.favorite,
                    color: widget.isLiked ? Colors.red : Colors.grey,
                  ),
                ),
                Text('${widget.likeCount}'),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: widget.onComment,
                  icon: const Icon(Icons.comment, color: Colors.grey),
                ),
                Text('${widget.commentCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection(List<Attachment> attachments) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    // If only one attachment, show it as a single image
    if (attachments.length == 1) {
      return _buildSingleAttachment(attachments.first);
    }

    // If multiple attachments, show them in a grid
    return _buildMultipleAttachments(attachments);
  }

  Widget _buildSingleAttachment(Attachment attachment) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 250,
        child: Image.network(
          attachment.secureUrl ?? '',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMultipleAttachments(List<Attachment> attachments) {
    // Show first 4 attachments in a 2x2 grid
    final displayAttachments = attachments.take(4).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: displayAttachments.length,
      itemBuilder: (context, index) {
        final attachment = displayAttachments[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            attachment.secureUrl ?? '',
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
