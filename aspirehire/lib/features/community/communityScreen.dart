// ignore_for_file: file_names

import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import 'package:aspirehire/features/community/components/FriendsCard.dart';
import 'package:aspirehire/features/community/components/RequestCard.dart';
import 'package:aspirehire/features/community/components/SectionHeader.dart';
import 'package:aspirehire/features/community/components/UserCard.dart';
import 'package:aspirehire/features/community/state_management/follower_cubit.dart';
import 'package:aspirehire/features/community/state_management/follower_state.dart';
import 'package:aspirehire/features/community/state_management/friend_cubit.dart';
import 'package:aspirehire/features/community/state_management/friend_state.dart';
import 'package:aspirehire/core/models/SearchProfileDTO.dart';
import 'package:aspirehire/core/models/Friend.dart';
import 'package:aspirehire/core/models/Follower.dart';
import 'package:aspirehire/features/people_search/state_management/search_users_cubit.dart';
import 'package:aspirehire/features/people_search/state_management/search_users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityScreenWrapper extends StatelessWidget {
  const CommunityScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchUsersCubit>(create: (context) => SearchUsersCubit()),
        BlocProvider<FriendCubit>(create: (context) => FriendCubit()),
        BlocProvider<FollowerCubit>(create: (context) => FollowerCubit()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          // Initialize the cubits here where we have access to the context
          final searchCubit = context.read<SearchUsersCubit>();
          final friendCubit = context.read<FriendCubit>();
          final followerCubit = context.read<FollowerCubit>();

          return CommunityScreen(
            searchCubit: searchCubit,
            friendCubit: friendCubit,
            followerCubit: followerCubit,
          );
        },
      ),
    );
  }
}

class CommunityScreen extends StatefulWidget {
  final SearchUsersCubit searchCubit;
  final FriendCubit friendCubit;
  final FollowerCubit followerCubit;

  const CommunityScreen({
    super.key,
    required this.searchCubit,
    required this.friendCubit,
    required this.followerCubit,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late String _token;
  final TextEditingController _searchController = TextEditingController();
  List<UserProfile> _searchResults = [];
  List<Friend> _friends = [];
  List<FriendRequest> _friendRequests = [];
  List<FollowerUser> _following = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    if (!mounted) return;

    _token = (await CacheHelper.getData('token')) ?? '';
    if (_token.isNotEmpty && mounted) {
      widget.searchCubit.searchUsers(_token, 'm');
      widget.friendCubit.getAllFriends(_token);
      widget.friendCubit.getAllFriendRequests(_token);
      widget.followerCubit.getAllFollowing(_token);
    }
  }

  void _handleUnfriend(String profileId) {
    setState(() {
      _friends.removeWhere((friend) => friend.profileId == profileId);
    });
    widget.friendCubit.unfriendUser(_token, profileId);
  }

  void _handleFriendRequest(String? userId, bool accept) {
    if (userId == null) return;
    setState(() {
      _friendRequests.removeWhere((request) => request.requester?.id == userId);
      if (accept) {
        // If accepted, add to friends list (you'll need to get the friend details)
        // This is a placeholder - you might want to fetch the friend details
        widget.friendCubit.getAllFriends(_token);
      }
    });
    widget.friendCubit.approveOrDeclineFriendRequest(_token, userId, accept);
  }

  void _handleUnfollow(String? profileId) {
    if (profileId == null) return;
    setState(() {
      _following.removeWhere((user) => user.profileId == profileId);
    });
    widget.followerCubit.followOrUnfollowUser(_token, profileId);
  }

  void _handleSearchItemPress(UserProfile user) {
    setState(() {
      _searchResults.removeWhere((item) => item.profileId == user.profileId);
    });
    widget.friendCubit.sendOrCancelFriendRequest(_token, user.profileId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _loadToken,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: People with similar interests
                    const SectionHeader(
                      title: "People with similar interests",
                      actionText: "See All",
                    ),
                    BlocBuilder<SearchUsersCubit, SearchUsersState>(
                      bloc: widget.searchCubit,
                      builder: (context, state) {
                        if (state is SearchUsersLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is SearchUsersLoaded) {
                          _searchResults = state.users;
                          if (_searchResults.isEmpty) {
                            return _buildEmptyState('No users found');
                          }
                          return SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final user = _searchResults[index];
                                return UserCard(
                                  name:
                                      user.role == 'Company'
                                          ? user.companyName ?? user.username
                                          : '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                              .trim(),
                                  profilePicture:
                                      user.profilePicture?.secureUrl,
                                  buttonText: "Add",
                                  onPressed: () => _handleSearchItemPress(user),
                                );
                              },
                            ),
                          );
                        } else if (state is SearchUsersError) {
                          if (state.message.contains('404')) {
                            return _buildEmptyState('No users found');
                          }
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 20),

                    // Tabs for Requests Section
                    const TabBar(
                      labelColor: Color(0xFF013E5D),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF013E5D),
                      tabs: [
                        Tab(text: "Requests"),
                        Tab(text: "Friends"),
                        Tab(text: "Following"),
                      ],
                    ),

                    // TabBarView (Each tab content)
                    SizedBox(
                      height: 500,
                      child: TabBarView(
                        children: [
                          // Requests Tab
                          BlocBuilder<FriendCubit, FriendState>(
                            bloc: widget.friendCubit,
                            builder: (context, state) {
                              if (state is FriendLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is FriendRequestsLoaded) {
                                _friendRequests = state.requests;
                                if (_friendRequests.isEmpty) {
                                  return _buildEmptyState('No friend requests');
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _friendRequests.length,
                                  itemBuilder: (context, index) {
                                    final request = _friendRequests[index];
                                    return RequestTCard(
                                      name:
                                          request.requester != null
                                              ? '${request.requester!.firstName} ${request.requester!.lastName}'
                                              : 'Unknown User',
                                      profilePicture:
                                          request.requester?.profilePictureUrl,
                                      acceptText: "Accept",
                                      rejectText: "Reject",
                                      onAccept:
                                          () => _handleFriendRequest(
                                            request.requester?.id,
                                            true,
                                          ),
                                      onReject:
                                          () => _handleFriendRequest(
                                            request.requester?.id,
                                            false,
                                          ),
                                    );
                                  },
                                );
                              } else if (state is FriendError) {
                                if (state.message.contains('404')) {
                                  return _buildEmptyState('No friend requests');
                                }
                                return Center(child: Text(state.message));
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          // Friends Tab
                          BlocBuilder<FriendCubit, FriendState>(
                            bloc: widget.friendCubit,
                            builder: (context, state) {
                              if (state is FriendLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is FriendsLoaded) {
                                _friends = state.friends;
                                if (_friends.isEmpty) {
                                  return _buildEmptyState('No friends yet');
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _friends.length,
                                  itemBuilder: (context, index) {
                                    final friend = _friends[index];
                                    return FriendsCard(
                                      name:
                                          '${friend.firstName} ${friend.lastName}',
                                      profilePicture:
                                          friend.profilePicture['secure_url'],
                                      friend: "Unfriend",
                                      onPressed:
                                          () =>
                                              _handleUnfriend(friend.profileId),
                                    );
                                  },
                                );
                              } else if (state is FriendError) {
                                if (state.message.contains('404')) {
                                  return _buildEmptyState('No friends yet');
                                }
                                return Center(child: Text(state.message));
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          // Following Tab
                          BlocBuilder<FollowerCubit, FollowerState>(
                            bloc: widget.followerCubit,
                            builder: (context, state) {
                              if (state is FollowerLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is FollowingLoaded) {
                                _following = state.following;
                                if (_following.isEmpty) {
                                  return _buildEmptyState(
                                    'Not following anyone yet',
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _following.length,
                                  itemBuilder: (context, index) {
                                    final user = _following[index];
                                    return FriendsCard(
                                      name:
                                          '${user.firstName} ${user.lastName}',
                                      profilePicture:
                                          user.profilePicture?.secureUrl,
                                      friend: "Unfollow",
                                      onPressed:
                                          () => _handleUnfollow(user.profileId),
                                    );
                                  },
                                );
                              } else if (state is FollowerError) {
                                if (state.message.contains('404')) {
                                  return _buildEmptyState(
                                    'Not following anyone yet',
                                  );
                                }
                                return Center(child: Text(state.message));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
