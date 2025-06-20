import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../company_home_screen/components/CompanyHomeHeader.dart';
import '../company_home_screen/components/CompanyHomeHeaderSkeleton.dart';
import '../company_home_screen/components/CompanyWritePostSkeleton.dart';
import '../../config/datasources/cache/shared_pref.dart';
import '../company_feed/state_management/company_feed_cubit.dart';
import '../company_feed/state_management/company_feed_states.dart';
import '../company_feed/state_management/company_like_cubit.dart';
import '../company_feed/state_management/company_like_state.dart';
import '../company_feed/components/CompanyPostCard.dart' as company_feed_post;
import '../company_feed/components/CompanyPostCardSkeleton.dart';
import '../company_feed/components/CompanyCommentBottomSheet.dart';
import '../company_feed/state_management/company_comment_cubit.dart';
import '../company_feed/state_management/company_comment_state.dart';
import '../company_profile/company_profile_cubit.dart';
import '../company_profile/company_profile_state.dart';
import '../seeker_profile/state_management/user_profile_cubit.dart';
import '../seeker_profile/state_management/user_profile_state.dart';
import '../../../core/utils/reaction_types.dart';
import '../company_create_post/CompanyCreatePost.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});

  @override
  _CompanyHomeScreenState createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  String? token;
  late CompanyFeedCubit feedCubit;
  late CompanyCommentCubit commentCubit;
  late CompanyLikeCubit likeCubit;
  late CompanyProfileCubit companyProfileCubit;

  // Current company user ID for reaction tracking
  String? _currentUserId;

  // Local state to track current reaction for each post
  final Map<String, dynamic> _postReactions = {};

  // Track current reaction operation for error handling
  String? _currentReactionOperationPostId;
  dynamic _previousReaction;

  @override
  void initState() {
    super.initState();
    feedCubit = CompanyFeedCubit();
    commentCubit = CompanyCommentCubit();
    likeCubit = CompanyLikeCubit();
    companyProfileCubit = CompanyProfileCubit();
    _fetchTokenAndData();
  }

  Future<void> _fetchTokenAndData() async {
    final t = await CacheHelper.getData('token');
    if (t != null) {
      setState(() => token = t);
      feedCubit.getFeed(t);
      companyProfileCubit.profile(t);
    }
  }

  // Helper method to get current reaction for a post
  dynamic _getPostReaction(post) {
    if (post.id == null) return null;
    if (_postReactions.containsKey(post.id)) {
      return _postReactions[post.id];
    }
    if (post.reacts != null && post.reacts!.isNotEmpty) {
      final currentUserId = _currentUserId;
      if (currentUserId != null) {
        for (final react in post.reacts!) {
          if (react.userId == currentUserId) {
            _postReactions[post.id!] = react.react;
            return react.react;
          }
        }
      }
    }
    _postReactions[post.id!] = null;
    return null;
  }

  void _updatePostReaction(String postId, dynamic reaction) {
    setState(() {
      _postReactions[postId] = reaction;
    });
  }

  @override
  void dispose() {
    feedCubit.close();
    commentCubit.close();
    likeCubit.close();
    companyProfileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: feedCubit),
        BlocProvider.value(value: commentCubit),
        BlocProvider.value(value: likeCubit),
        BlocProvider.value(value: companyProfileCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<CompanyProfileCubit, CompanyProfileState>(
                builder: (context, state) {
                  if (state is CompanyProfileLoading) {
                    return const CompanyHomeHeaderSkeleton();
                  } else if (state is CompanyProfileLoaded) {
                    final company = state.data.user;
                    _currentUserId = company.profileId;
                    return CompanyHomeHeader(
                      firstName: company.companyName,
                      lastName: '',
                      profilePicture: company.profilePicture?.secureUrl,
                    );
                  } else if (state is CompanyProfileError) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error loading profile: ${state.message}'),
                    );
                  }
                  return const CompanyHomeHeaderSkeleton();
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocListener<CompanyLikeCubit, CompanyLikeState>(
                  listener: (context, likeState) {
                    if (likeState is CompanyLikeSuccess) {
                      _currentReactionOperationPostId = null;
                      _previousReaction = null;
                    } else if (likeState is CompanyLikeError) {
                      if (_currentReactionOperationPostId != null &&
                          _previousReaction != null) {
                        _updatePostReaction(
                          _currentReactionOperationPostId!,
                          _previousReaction,
                        );
                        _currentReactionOperationPostId = null;
                        _previousReaction = null;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${likeState.message}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: BlocListener<CompanyCommentCubit, CompanyCommentState>(
                    listener: (context, commentState) {
                      if (commentState is CompanyCommentCreated) {
                        if (token != null) {
                          feedCubit.getFeed(token!);
                        }
                      }
                    },
                    child: BlocBuilder<CompanyFeedCubit, CompanyFeedState>(
                      builder: (context, state) {
                        if (state is CompanyFeedLoading) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              if (token != null) {
                                feedCubit.getFeed(token!);
                                companyProfileCubit.profile(token!);
                              }
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return const CompanyWritePostSkeleton();
                                }
                                return const CompanyPostCardSkeleton();
                              },
                            ),
                          );
                        } else if (state is CompanyFeedLoaded) {
                          final posts = state.feedResponse.data;
                          return RefreshIndicator(
                            onRefresh: () async {
                              if (token != null) {
                                feedCubit.getFeed(token!);
                                companyProfileCubit.profile(token!);
                              }
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              itemCount: posts.length + 1,
                              itemBuilder: (context, index) {
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
                                                    const CompanyCreatePost(),
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
                                final post = posts[index - 1].post;
                                final commentCount = post.comments?.length ?? 0;
                                final currentReaction = _getPostReaction(post);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: company_feed_post.CompanyPostCard(
                                    post: post,
                                    currentReaction: currentReaction,
                                    commentCount: commentCount,
                                    token: token,
                                    onReaction: (reactionType) async {
                                      if (token != null && post.id != null) {
                                        final previousReaction =
                                            currentReaction;
                                        _currentReactionOperationPostId =
                                            post.id;
                                        _previousReaction = previousReaction;
                                        _updatePostReaction(
                                          post.id!,
                                          reactionType,
                                        );
                                        await likeCubit.likeOrDislikePost(
                                          token!,
                                          post.id!,
                                          ReactionUtils.getReactionString(
                                            reactionType,
                                          ),
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
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder:
                                              (context) => BlocProvider.value(
                                                value: commentCubit,
                                                child:
                                                    CompanyCommentBottomSheet(
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
                        } else if (state is CompanyFeedError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const CompanyWritePostSkeleton();
                            }
                            return const CompanyPostCardSkeleton();
                          },
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
