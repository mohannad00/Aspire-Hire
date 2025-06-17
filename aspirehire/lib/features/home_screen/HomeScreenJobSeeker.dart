import 'package:aspirehire/features/create_post/CreatePost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/home_screen/components/HomeHeader.dart';
import 'package:aspirehire/features/home_screen/components/HomeHeaderSkeleton.dart';
import 'package:aspirehire/features/home_screen/components/WritePostSkeleton.dart';
import '../../config/datasources/cache/shared_pref.dart';
import '../profile/state_management/profile_cubit.dart';
import '../profile/state_management/profile_state.dart';
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

  // Local state to track like status for each post
  final Map<String, bool> _postLikeStatus = {};

  // Local state to track like counts for each post
  final Map<String, int> _postLikeCounts = {};

  // Track current like operation for error handling
  String? _currentLikeOperationPostId;
  bool? _previousLikeStatus;
  int? _previousLikeCount;

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

  // Helper method to get like status for a post
  bool _getPostLikeStatus(Post post) {
    if (post.id == null) return false;

    // If we have a local status, use it
    if (_postLikeStatus.containsKey(post.id)) {
      return _postLikeStatus[post.id]!;
    }

    // Otherwise, calculate from API data
    final apiLikeStatus = post.reacts?.any((r) => r.react == 'Love') ?? false;
    _postLikeStatus[post.id!] = apiLikeStatus; // Cache the initial status
    return apiLikeStatus;
  }

  // Helper method to update like status for a post
  void _updatePostLikeStatus(String postId, bool isLiked) {
    setState(() {
      _postLikeStatus[postId] = isLiked;
    });
  }

  // Helper method to get like count for a post
  int _getPostLikeCount(Post post) {
    if (post.id == null) return 0;

    // If we have a local count, use it
    if (_postLikeCounts.containsKey(post.id)) {
      return _postLikeCounts[post.id]!;
    }

    // Otherwise, use the API data
    final apiLikeCount = post.reacts?.length ?? 0;
    _postLikeCounts[post.id!] = apiLikeCount; // Cache the initial count
    return apiLikeCount;
  }

  // Helper method to update like count for a post
  void _updatePostLikeCount(String postId, int newCount) {
    setState(() {
      _postLikeCounts[postId] = newCount;
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
                      _currentLikeOperationPostId = null;
                      _previousLikeStatus = null;
                      _previousLikeCount = null;
                    } else if (likeState is LikeError) {
                      // If the API call failed, revert the local state
                      if (_currentLikeOperationPostId != null &&
                          _previousLikeStatus != null &&
                          _previousLikeCount != null) {
                        // Revert the like status and count
                        _updatePostLikeStatus(
                          _currentLikeOperationPostId!,
                          _previousLikeStatus!,
                        );
                        _updatePostLikeCount(
                          _currentLikeOperationPostId!,
                          _previousLikeCount!,
                        );

                        // Clear tracking variables
                        _currentLikeOperationPostId = null;
                        _previousLikeStatus = null;
                        _previousLikeCount = null;
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
                                                (context) => const CreatePost(),
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
                                final likeCount = _getPostLikeCount(post);
                                final commentCount = post.comments?.length ?? 0;
                                final isLiked = _getPostLikeStatus(post);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: feed_post.PostCard(
                                    post: post,
                                    isLiked: isLiked,
                                    likeCount: likeCount,
                                    commentCount: commentCount,
                                    onLike: () {
                                      if (token != null && post.id != null) {
                                        final currentLikeStatus =
                                            _getPostLikeStatus(post);
                                        final newLikeStatus =
                                            !currentLikeStatus;
                                        final currentLikeCount =
                                            _getPostLikeCount(post);

                                        // Store previous state for error handling
                                        final previousLikeStatus =
                                            currentLikeStatus;
                                        final previousLikeCount =
                                            currentLikeCount;

                                        // Track current operation
                                        _currentLikeOperationPostId = post.id;
                                        _previousLikeStatus =
                                            previousLikeStatus;
                                        _previousLikeCount = previousLikeCount;

                                        // Update local state immediately for instant UI feedback
                                        _updatePostLikeStatus(
                                          post.id!,
                                          newLikeStatus,
                                        );

                                        // Update like count
                                        final newLikeCount =
                                            newLikeStatus
                                                ? currentLikeCount + 1
                                                : currentLikeCount - 1;
                                        _updatePostLikeCount(
                                          post.id!,
                                          newLikeCount,
                                        );

                                        // Call the API
                                        likeCubit.likeOrDislikePost(
                                          token!,
                                          post.id!,
                                          newLikeStatus ? 'Love' : 'Like',
                                        );
                                      }
                                    },
                                    onComment: () {
                                      if (token != null && post.id != null) {
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
                                      MediaQuery.of(context).size.height * 0.3,
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
            ],
          ),
        ),
      ),
    );
  }
}
