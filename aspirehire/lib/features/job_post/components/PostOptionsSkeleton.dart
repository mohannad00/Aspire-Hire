import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostOptionsSkeleton extends StatelessWidget {
  const PostOptionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          _buildOptionSkeleton(),
          _buildOptionSkeleton(),
          _buildOptionSkeleton(),
        ],
      ),
    );
  }

  Widget _buildOptionSkeleton() {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      title: Container(
        width: 80,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
