import 'package:aspirehire/features/create_post/CreatePost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/home_screen/components/HomeHeader.dart';
import 'package:aspirehire/features/home_screen/components/HomeHeaderSkeleton.dart';
import 'package:aspirehire/features/home_screen/components/WritePostSkeleton.dart';
import '../../config/datasources/cache/shared_pref.dart';
import '../seeker_profile/state_management/profile_cubit.dart';
import '../seeker_profile/state_management/profile_state.dart';
import '../feed/state_management/feed_cubit.dart';
import '../feed/state_management/feed_states.dart';
import '../feed/state_management/like_cubit.dart';
import '../feed/state_management/like_state.dart';
import '../feed/components/PostCard.dart' as feed_post;
import '../feed/components/PostCardSkeleton.dart';
import '../feed/components/CommentBottomSheet.dart';
import '../community/state_management/comment_cubit.dart';
import '../community/state_management/comment_state.dart';
import '../../core/models/Feed.dart';
import '../../core/utils/reaction_types.dart';
import 'package:dio/dio.dart';
import '../../config/datasources/api/end_points.dart';
import '../../core/models/Post.dart';
import '../home_screen/components/HomeHeader.dart';
import '../home_screen/components/HomeHeaderSkeleton.dart';
import '../home_screen/components/WritePostSkeleton.dart';

class HomeScreenJobSeeker extends StatefulWidget {
  const HomeScreenJobSeeker({super.key});

  @override
  _HomeScreenJobSeekerState createState() => _HomeScreenJobSeekerState();
}

class _HomeScreenJobSeekerState extends State<HomeScreenJobSeeker> {
  String? token;
  late FeedCubit feedCubit;
  late CommentCubit commentCubit;
  late LikeCubit likeCubit;
  late ProfileCubit profileCubit;

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
    feedCubit = FeedCubit();
    commentCubit = CommentCubit();
    likeCubit = LikeCubit();
    profileCubit = ProfileCubit();
    _fetchTokenAndData();
  }

  Future<void> _fetchTokenAndData() async {
    print('🔍 [HomeScreenJobSeeker] Fetching token...');
    final t = await CacheHelper.getData('token');
    print(
      '🔍 [HomeScreenJobSeeker] Token retrieved: ${t != null ? '${t.substring(0, 20)}...' : 'null'}',
    );
    if (t != null) {
      setState(() => token = t);
      print('🔍 [HomeScreenJobSeeker] Calling getFeed with token...');
      feedCubit.getFeed(t);
      print('🔍 [HomeScreenJobSeeker] Calling getProfile with token...');
      profileCubit.getProfile(t);
    } else {
      print('🔍 [HomeScreenJobSeeker] No token found!');
    }
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
      final currentUserId = _getCurrentUserId();
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

  // Helper method to get current user ID
  String? _getCurrentUserId() {
    return _currentUserId;
  }

  // Helper method to refresh reactions after getting user ID
  void _refreshReactions() {
    // Clear existing reactions and rebuild to check actual reactions
    setState(() {
      _postReactions.clear();
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
      print('🔍 [HomeScreenJobSeeker] Cancel reaction error: ${e.message}');
      throw e;
    }
  }

  // Helper method to update reaction for a post
  void _updatePostReaction(String postId, ReactionType? reaction) {
    setState(() {
      _postReactions[postId] = reaction;
    });
  }

  @override
  void dispose() {
    feedCubit.close();
    commentCubit.close();
    likeCubit.close();
    profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: feedCubit),
        BlocProvider.value(value: commentCubit),
        BlocProvider.value(value: likeCubit),
        BlocProvider.value(value: profileCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Home Header
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  if (profileState is ProfileLoading) {
                    return const HomeHeaderSkeleton();
                  } else if (profileState is ProfileLoaded) {
                    return HomeHeader(
                      firstName: profileState.profile.firstName,
                      lastName: profileState.profile.lastName,
                      profilePicture:
                          profileState.profile.profilePicture!.secureUrl,
                    );
                  } else if (profileState is ProfileError) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error loading profile: ${profileState.message}',
                      ),
                    );
                  }
                  return const HomeHeaderSkeleton();
                },
              ),
              const SizedBox(height: 10),

              // Write Post Text Field

              // ListView of Posts
              Expanded(
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
                        // Refresh feed data to update comment counts
                        if (token != null) {
                          feedCubit.getFeed(token!);
                        }
                      }
                    },
                    child: BlocListener<ProfileCubit, ProfileState>(
                      listener: (context, profileState) {
                        if (profileState is ProfileLoaded) {
                          setState(() {
                            _currentUserId = profileState.profile.profileId;
                          });
                          // Refresh reactions after getting user ID
                          _refreshReactions();
                        }
                      },
                      child: BlocBuilder<FeedCubit, FeedState>(
                        builder: (context, state) {
                          if (state is FeedLoading) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                if (token != null) {
                                  feedCubit.getFeed(token!);
                                  profileCubit.getProfile(token!);
                                }
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                itemCount:
                                    6, // +1 for write post skeleton, +5 for post skeletons
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return const WritePostSkeleton();
                                  }
                                  return const PostCardSkeleton();
                                },
                              ),
                            );
                          } else if (state is FeedLoaded) {
                            final posts = state.feedResponse.data;

                            return RefreshIndicator(
                              onRefresh: () async {
                                if (token != null) {
                                  feedCubit.getFeed(token!);
                                  profileCubit.getProfile(token!);
                                }
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                itemCount:
                                    posts.length +
                                    1, // +1 for the write post item
                                itemBuilder: (context, index) {
                                  // First item is the write post GestureDetector
                                  if (index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const CreatePost(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 0.5,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Text(
                                            "Write a post",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  // Regular posts (index - 1 because we added the write post item)
                                  final post = posts[index - 1].post;
                                  final commentCount =
                                      post.comments?.length ?? 0;
                                  final currentReaction = _getPostReaction(
                                    post,
                                  );

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: feed_post.PostCard(
                                      post: post,
                                      currentReaction: currentReaction,
                                      commentCount: commentCount,
                                      token: token,
                                      onReaction: (reactionType) async {
                                        if (token != null && post.id != null) {
                                          final currentReaction =
                                              _getPostReaction(post);
                                          final currentUserId =
                                              _getCurrentUserId();

                                          // Helper to update the local reacts list
                                          void updateLocalReacts({
                                            ReactionType? newReaction,
                                          }) {
                                            setState(() {
                                              post.reacts ??= [];
                                              // Remove any previous reaction by this user
                                              post.reacts!.removeWhere(
                                                (r) =>
                                                    r.userId == currentUserId,
                                              );
                                              if (newReaction != null) {
                                                // Add the new reaction
                                                post.reacts!.add(
                                                  React(
                                                    userId: currentUserId,
                                                    react:
                                                        ReactionUtils.getReactionString(
                                                          newReaction,
                                                        ),
                                                  ),
                                                );
                                              }
                                            });
                                          }

                                          // If user is selecting the same reaction, remove it
                                          if (currentReaction == reactionType) {
                                            final previousReaction =
                                                currentReaction;
                                            _currentReactionOperationPostId =
                                                post.id;
                                            _previousReaction =
                                                previousReaction;
                                            _updatePostReaction(post.id!, null);
                                            updateLocalReacts(
                                              newReaction: null,
                                            );
                                            await likeCubit.likeOrDislikePost(
                                              token!,
                                              post.id!,
                                              ReactionUtils.getReactionString(
                                                reactionType,
                                              ),
                                            );
                                          } else {
                                            final previousReaction =
                                                currentReaction;
                                            _currentReactionOperationPostId =
                                                post.id;
                                            _previousReaction =
                                                previousReaction;
                                            _updatePostReaction(
                                              post.id!,
                                              reactionType,
                                            );
                                            updateLocalReacts(
                                              newReaction: reactionType,
                                            );
                                            if (previousReaction != null) {
                                              try {
                                                await _cancelReaction(
                                                  token!,
                                                  post.id!,
                                                  previousReaction,
                                                );
                                                await likeCubit.likeOrDislikePost(
                                                  token!,
                                                  post.id!,
                                                  ReactionUtils.getReactionString(
                                                    reactionType,
                                                  ),
                                                );
                                              } catch (e) {
                                                _updatePostReaction(
                                                  post.id!,
                                                  previousReaction,
                                                );
                                                updateLocalReacts(
                                                  newReaction: previousReaction,
                                                );
                                                _currentReactionOperationPostId =
                                                    null;
                                                _previousReaction = null;
                                              }
                                            } else {
                                              await likeCubit.likeOrDislikePost(
                                                token!,
                                                post.id!,
                                                ReactionUtils.getReactionString(
                                                  reactionType,
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                      onComment: () {
                                        if (token != null && post.id != null) {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(50),
                                                  ),
                                            ),
                                            builder:
                                                (context) => BlocProvider.value(
                                                  value: commentCubit,
                                                  child: CommentBottomSheet(
                                                    postId: post.id!,
                                                    token: token!,
                                                  ),
                                                ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (state is FeedError) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                if (token != null) {
                                  feedCubit.getFeed(token!);
                                  profileCubit.getProfile(token!);
                                }
                              },
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Error loading feed',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            state.message,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Pull down to refresh',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          // Show skeletons for initial state
                          return RefreshIndicator(
                            onRefresh: () async {
                              if (token != null) {
                                feedCubit.getFeed(token!);
                                profileCubit.getProfile(token!);
                              }
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              itemCount:
                                  6, // +1 for write post skeleton, +5 for post skeletons
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return const WritePostSkeleton();
                                }
                                return const PostCardSkeleton();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
