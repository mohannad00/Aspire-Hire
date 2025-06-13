import 'package:flutter/material.dart';
import '../../../core/models/Feed.dart';

class PostCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final publisher =
        post.publisher?.isNotEmpty == true ? post.publisher!.first : null;
    final profilePic = publisher?.profilePicture?.secureUrl;
    final name =
        publisher != null
            ? (publisher.firstName ?? '') + ' ' + (publisher.lastName ?? '')
            : 'Unknown';
    final username = publisher?.username ?? '';
    final content = post.content ?? '';
    final tags = post.tags ?? [];
    final attachments = post.attachments ?? [];
    final createdAt =
        post.createdAt != null ? DateTime.tryParse(post.createdAt!) : null;
    final imageUrl =
        attachments.isNotEmpty ? attachments.first.secureUrl : null;

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
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      profilePic != null ? NetworkImage(profilePic) : null,
                  child: profilePic == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@$username',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
              ],
            ),
            const SizedBox(height: 10),
            if (content.isNotEmpty)
              Text(content, style: const TextStyle(fontSize: 15)),
            if (imageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (c, e, s) => const SizedBox(),
                ),
              ),
            ],
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: onLike,
                  icon: Icon(
                    Icons.favorite,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                ),
                Text('$likeCount'),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: onComment,
                  icon: const Icon(Icons.comment, color: Colors.grey),
                ),
                Text('$commentCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
