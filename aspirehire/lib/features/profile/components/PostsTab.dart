import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../core/models/Feed.dart';
import '../../../core/models/Post.dart';
import '../../../core/utils/reaction_types.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../feed/state_management/like_cubit.dart';
import '../../feed/state_management/like_state.dart';
import '../../feed/components/CommentBottomSheet.dart';
import '../../community/state_management/comment_cubit.dart';
import '../../community/state_management/comment_state.dart';
import 'ProfilePostCard.dart';

class PostsTab extends StatefulWidget {
  final List<Post> basicPosts;
  final bool isRefreshing;
  final String? token;
  final String? currentUserId;

  const PostsTab({
    Key? key,
    required this.basicPosts,
    this.isRefreshing = false,
    this.token,
    this.currentUserId,
  }) : super(key: key);

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  late LikeCubit likeCubit;
  late CommentCubit commentCubit;

  // Current user ID for reaction tracking
  String? _currentUserId;

  // Local state to track current reaction for each post
  final Map<String, ReactionType?> _postReactions = {};

  // Track current reaction operation for error handling
  String? _currentReactionOperationPostId;
  ReactionType? _previousReaction;

  @override
  void initState() {
    super.initState();
    likeCubit = LikeCubit();
    commentCubit = CommentCubit();
    _currentUserId = widget.currentUserId;
  }

  @override
  void dispose() {
    likeCubit.close();
    commentCubit.close();
    super.dispose();
  }

  // Helper method to get current user ID
  Future<void> _getCurrentUserId() async {
    // Get current user ID from cache or profile data
    // For now, we'll need to get it from the parent component
    // This should be passed down from UserProfileScreen
  }

  // Helper method to get current reaction for a post
  ReactionType? _getPostReaction(Post post) {
    if (post.id == null) return null;

    // If we have a local reaction, use it (for immediate UI feedback)
    if (_postReactions.containsKey(post.id)) {
      return _postReactions[post.id];
    }

    // Check actual reactions from the post data to see if current user has reacted
    if (post.reacts != null && post.reacts!.isNotEmpty) {
      // Get current user ID from profile data
      final currentUserId = _currentUserId;
      if (currentUserId != null) {
        // Find if current user has reacted to this post
        for (final react in post.reacts!) {
          if (react.userId == currentUserId) {
            final reactionType = ReactionUtils.getReactionTypeFromString(
              react.react,
            );
            if (reactionType != null) {
              // Store this reaction locally for future reference
              _postReactions[post.id!] = reactionType;
              return reactionType;
            }
          }
        }
      }
    }

    // No reaction found
    _postReactions[post.id!] = null;
    return null;
  }

  // Helper method to update reaction for a post
  void _updatePostReaction(String postId, ReactionType? reaction) {
    setState(() {
      _postReactions[postId] = reaction;
    });
  }

  // Helper method to cancel a reaction
  Future<void> _cancelReaction(
    String token,
    String postId,
    ReactionType reactionType,
  ) async {
    final dio = Dio();
    try {
      final request =
          LikePostRequest()
            ..react = ReactionUtils.getReactionString(reactionType);

      await dio.post(
        ApiEndpoints.likeOrDislikePost.replaceAll(':postId', postId),
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
        ),
      );
    } on DioException catch (e) {
      print('🔍 [PostsTab] Cancel reaction error: ${e.message}');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.basicPosts.reversed.toList();

    if (widget.basicPosts.isEmpty) {
      return _buildEmptyState();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: likeCubit),
        BlocProvider.value(value: commentCubit),
      ],
      child: BlocListener<LikeCubit, LikeState>(
        listener: (context, likeState) {
          if (likeState is LikeSuccess) {
            // API call succeeded, clear tracking variables
            _currentReactionOperationPostId = null;
            _previousReaction = null;
          } else if (likeState is LikeError) {
            // If the API call failed, revert the local state
            if (_currentReactionOperationPostId != null &&
                _previousReaction != null) {
              // Revert the reaction
              _updatePostReaction(
                _currentReactionOperationPostId!,
                _previousReaction,
              );

              // Clear tracking variables
              _currentReactionOperationPostId = null;
              _previousReaction = null;
            }

            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${likeState.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocListener<CommentCubit, CommentState>(
          listener: (context, commentState) {
            if (commentState is CommentCreated) {
              // Could refresh posts here if needed
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == posts.length) {
                return const SizedBox(height: 100);
              }

              final post = posts[index];
              final currentReaction = _getPostReaction(post);
              final commentCount = post.comments?.length ?? 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProfilePostCard(
                  post: post,
                  currentReaction: currentReaction,
                  commentCount: commentCount,
                  token: widget.token,
                  onReaction: (reactionType) async {
                    if (widget.token != null && post.id != null) {
                      final currentReaction = _getPostReaction(post);
                      final currentUserId = _currentUserId;

                      // Helper to update the local reacts list
                      void updateLocalReacts({ReactionType? newReaction}) {
                        setState(() {
                          post.reacts ??= [];
                          // Remove any previous reaction by this user
                          post.reacts!.removeWhere(
                            (r) => r.userId == currentUserId,
                          );
                          if (newReaction != null) {
                            // Add the new reaction
                            post.reacts!.add(
                              React(
                                userId: currentUserId,
                                react: ReactionUtils.getReactionString(
                                  newReaction,
                                ),
                              ),
                            );
                          }
                        });
                      }

                      // If user is selecting the same reaction, remove it
                      if (currentReaction == reactionType) {
                        final previousReaction = currentReaction;
                        _currentReactionOperationPostId = post.id;
                        _previousReaction = previousReaction;
                        _updatePostReaction(post.id!, null);
                        updateLocalReacts(newReaction: null);
                        await likeCubit.likeOrDislikePost(
                          widget.token!,
                          post.id!,
                          ReactionUtils.getReactionString(reactionType),
                        );
                      } else {
                        final previousReaction = currentReaction;
                        _currentReactionOperationPostId = post.id;
                        _previousReaction = previousReaction;
                        _updatePostReaction(post.id!, reactionType);
                        updateLocalReacts(newReaction: reactionType);
                        if (previousReaction != null) {
                          try {
                            await _cancelReaction(
                              widget.token!,
                              post.id!,
                              previousReaction,
                            );
                            await likeCubit.likeOrDislikePost(
                              widget.token!,
                              post.id!,
                              ReactionUtils.getReactionString(reactionType),
                            );
                          } catch (e) {
                            _updatePostReaction(post.id!, previousReaction);
                            updateLocalReacts(newReaction: previousReaction);
                            _currentReactionOperationPostId = null;
                            _previousReaction = null;
                          }
                        } else {
                          await likeCubit.likeOrDislikePost(
                            widget.token!,
                            post.id!,
                            ReactionUtils.getReactionString(reactionType),
                          );
                        }
                      }
                    }
                  },
                  onComment: () {
                    if (widget.token != null && post.id != null) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                        builder:
                            (context) => BlocProvider.value(
                              value: commentCubit,
                              child: CommentBottomSheet(
                                postId: post.id!,
                                token: widget.token!,
                              ),
                            ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
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
