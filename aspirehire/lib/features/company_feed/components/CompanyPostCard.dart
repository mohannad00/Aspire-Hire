import 'package:flutter/material.dart';
import '../../../core/models/Feed.dart';
import '../../../core/utils/reaction_types.dart';
// import '../../profile/screens/UserProfileScreen.dart'; // Uncomment and adjust if you have a company profile screen
import '../../feed/components/ReactionPicker.dart';
import '../../feed/components/ReactionCounter.dart';
import '../../feed/components/ReactionsBottomSheet.dart';

class CompanyPostCard extends StatefulWidget {
  final Post post;
  final Future<void> Function(ReactionType)? onReaction;
  final VoidCallback? onComment;
  final ReactionType? currentReaction;
  final int commentCount;
  final String? token;

  const CompanyPostCard({
    Key? key,
    required this.post,
    this.onReaction,
    this.onComment,
    this.currentReaction,
    this.commentCount = 0,
    this.token,
  }) : super(key: key);

  @override
  State<CompanyPostCard> createState() => _CompanyPostCardState();
}

class _CompanyPostCardState extends State<CompanyPostCard> {
  bool _isExpanded = false;
  static const int _maxLines = 6;
  final GlobalKey _reactButtonKey = GlobalKey();

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
      shadowColor: Colors.grey.withOpacity(0.5),
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
                  // onTap: () => _navigateToUserProfile(publisher), // Uncomment if you have a company profile screen
                  child: CircleAvatar(
                    backgroundImage:
                        profilePic != null ? NetworkImage(profilePic) : null,
                    child: profilePic == null ? const Icon(Icons.person) : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    // onTap: () => _navigateToUserProfile(publisher), // Uncomment if you have a company profile screen
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

            const SizedBox(height: 10),

            // Reaction counter
            if (widget.post.reacts != null &&
                widget.post.reacts!.isNotEmpty) ...[
              ReactionCounter(
                reacts: widget.post.reacts,
                onTap: () => _showReactionsBottomSheet(context),
              ),
              const SizedBox(height: 8),
            ],

            // Action buttons
            Row(
              children: [
                // React button
                GestureDetector(
                  key: _reactButtonKey,
                  onTap: () async {
                    if (widget.onReaction != null) {
                      final currentReaction = widget.currentReaction;
                      if (currentReaction != null) {
                        // If already reacted, remove reaction
                        await widget.onReaction!(currentReaction);
                      } else {
                        // If no reaction, show picker
                        _showReactionPicker(context);
                      }
                    }
                  },
                  onLongPress: () => _showReactionPicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.currentReaction != null
                              ? ReactionUtils.getReactionData(
                                widget.currentReaction!,
                              ).color.withOpacity(0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.currentReaction != null
                              ? ReactionUtils.getReactionData(
                                widget.currentReaction!,
                              ).icon
                              : Icons.thumb_up_outlined,
                          color:
                              widget.currentReaction != null
                                  ? ReactionUtils.getReactionData(
                                    widget.currentReaction!,
                                  ).color
                                  : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.currentReaction != null
                              ? ReactionUtils.getReactionData(
                                widget.currentReaction!,
                              ).name
                              : 'React',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                widget.currentReaction != null
                                    ? ReactionUtils.getReactionData(
                                      widget.currentReaction!,
                                    ).color
                                    : Colors.grey,
                            fontWeight:
                                widget.currentReaction != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Comment button
                GestureDetector(
                  onTap: widget.onComment,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.comment_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Comment${widget.commentCount > 0 ? ' (${widget.commentCount})' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReactionPicker(BuildContext context) {
    final RenderBox? renderBox =
        _reactButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;
    final pickerWidth = 280.0;
    final pickerHeight = 80.0;
    double leftPosition = position.dx + (size.width / 2) - (pickerWidth / 2);
    if (leftPosition < 16) {
      leftPosition = 16;
    } else if (leftPosition + pickerWidth > screenSize.width - 16) {
      leftPosition = screenSize.width - pickerWidth - 16;
    }
    double topPosition = position.dy - pickerHeight - 20;
    if (topPosition < 16) {
      topPosition = position.dy + size.height + 20;
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder:
          (context) => GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(child: Container(color: Colors.transparent)),
                  Positioned(
                    top: topPosition,
                    left: leftPosition,
                    child: GestureDetector(
                      onTap: () {},
                      child: ReactionPicker(
                        currentReaction: widget.currentReaction,
                        onReactionSelected: (reactionType) async {
                          if (widget.onReaction != null) {
                            await widget.onReaction!(reactionType);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showReactionsBottomSheet(BuildContext context) {
    if (widget.post.id != null && widget.token != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (context) => ReactionsBottomSheet(
              postId: widget.post.id!,
              token: widget.token!,
            ),
      );
    }
  }

  Widget _buildAttachmentsSection(List<Attachment> attachments) {
    if (attachments.isEmpty) return const SizedBox.shrink();
    if (attachments.length == 1) {
      return _buildSingleAttachment(attachments.first);
    }
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
