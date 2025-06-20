import 'package:flutter/material.dart';
import '../../../core/models/Feed.dart';
import 'ProfilePostCard.dart';

class PostsTab extends StatefulWidget {
  final List<Post> basicPosts;
  final bool isRefreshing;

  const PostsTab({
    Key? key,
    required this.basicPosts,
    this.isRefreshing = false,
  }) : super(key: key);

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  @override
  Widget build(BuildContext context) {
    final posts = widget.basicPosts.reversed.toList();

    if (widget.basicPosts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length + 1,
      itemBuilder: (context, index) {
        if (index == posts.length) {
          return const SizedBox(height: 100);
        }

        final post = posts[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ProfilePostCard(post: post),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.post_add, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This user hasn\'t shared any posts yet.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
