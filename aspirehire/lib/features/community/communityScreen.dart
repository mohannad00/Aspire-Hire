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
        BlocProvider<FollowerCubit>(create: (context) => FollowerCubit()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final searchCubit = context.read<SearchUsersCubit>();
          final followerCubit = context.read<FollowerCubit>();

          return CommunityScreen(
            searchCubit: searchCubit,
            followerCubit: followerCubit,
          );
        },
      ),
    );
  }
}

class CommunityScreen extends StatefulWidget {
  final SearchUsersCubit searchCubit;
  final FollowerCubit followerCubit;

  const CommunityScreen({
    super.key,
    required this.searchCubit,
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

  // Create separate cubit instances for each tab
  late final FriendCubit _requestsCubit;
  late final FriendCubit _friendsCubit;

  // Track button states
  Set<String> _pendingFriendRequests = {};
  Set<String> _pendingUnfriendActions = {};
  Set<String> _pendingFollowActions = {};
  Set<String> _pendingUnfollowActions = {};

  // Track button text changes
  Set<String> _followedUsers = {}; // Users that have been followed
  Set<String> _unfriendedUsers = {}; // Users that have been unfriended
  Set<String> _unfollowedUsers = {}; // Users that have been unfollowed

  @override
  void initState() {
    super.initState();
    // Initialize separate cubit instances
    _requestsCubit = FriendCubit();
    _friendsCubit = FriendCubit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    if (!mounted) return;

    _token = (await CacheHelper.getData('token')) ?? '';
    if (_token.isNotEmpty && mounted) {
      widget.searchCubit.searchUsers(_token, 'm');
      _friendsCubit.getAllFriends(_token);
      _requestsCubit.getAllFriendRequests(_token);
      widget.followerCubit.getAllFollowing(_token);
    }
  }

  void _handleUnfriend(String profileId) {
    setState(() {
      _pendingUnfriendActions.add(profileId);
    });
    _friendsCubit.unfriendUser(_token, profileId);
  }

  void _handleFriendRequest(String? userId, bool accept) {
    if (userId == null) return;
    setState(() {
      _pendingFriendRequests.add(userId);
    });
    _requestsCubit.approveOrDeclineFriendRequest(_token, userId, accept);
  }

  void _handleUnfollow(String? profileId) {
    if (profileId == null) return;
    setState(() {
      _pendingUnfollowActions.add(profileId);
    });
    widget.followerCubit.followOrUnfollowUser(_token, profileId);
  }

  void _handleSearchItemPress(UserProfile user) {
    setState(() {
      _pendingFollowActions.add(user.profileId);
    });
    _friendsCubit.sendOrCancelFriendRequest(_token, user.profileId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _requestsCubit.close();
    _friendsCubit.close();
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: const Color(0xFF044463),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Community',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
                      title: 'People with similar interests',
                      actionText: 'See All',
                    ),
                    const SizedBox(height: 16),

                    // Search section with BlocListener
                    BlocListener<FriendCubit, FriendState>(
                      bloc: _friendsCubit,
                      listener: (context, state) {
                        if (state is FriendRequestSent) {
                          setState(() {
                            _pendingFollowActions.clear();
                          });
                        } else if (state is FriendError) {
                          setState(() {
                            _pendingFollowActions.clear();
                          });
                        }
                      },
                      child: BlocBuilder<SearchUsersCubit, SearchUsersState>(
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
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final user = _searchResults[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: UserCard(
                                      name:
                                          user.role == 'Company'
                                              ? user.companyName ??
                                                  user.username
                                              : '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                                  .trim(),
                                      profilePicture:
                                          user.profilePicture?.secureUrl,
                                      buttonText:
                                          _pendingFollowActions.contains(
                                                user.profileId,
                                              )
                                              ? "Pending..."
                                              : "Add",
                                      onPressed:
                                          _pendingFollowActions.contains(
                                                user.profileId,
                                              )
                                              ? null
                                              : () =>
                                                  _handleSearchItemPress(user),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (state is SearchUsersError) {
                            return Center(child: Text(state.message));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
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
                          BlocProvider<FriendCubit>(
                            create: (context) => _requestsCubit,
                            child: BlocListener<FriendCubit, FriendState>(
                              bloc: _requestsCubit,
                              listener: (context, state) {
                                if (state is FriendRequestApproved) {
                                  setState(() {
                                    _pendingFriendRequests.clear();
                                  });
                                } else if (state is FriendError) {
                                  setState(() {
                                    _pendingFriendRequests.clear();
                                  });
                                }
                              },
                              child: BlocBuilder<FriendCubit, FriendState>(
                                bloc: _requestsCubit,
                                builder: (context, state) {
                                  if (state is FriendLoading &&
                                      _friendRequests.isEmpty) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is FriendRequestsLoaded) {
                                    _friendRequests = state.requests;
                                    if (_friendRequests.isEmpty) {
                                      return _buildEmptyState(
                                        'No friend requests',
                                      );
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
                                              request
                                                  .requester
                                                  ?.profilePictureUrl,
                                          acceptText:
                                              _pendingFriendRequests.contains(
                                                    request.requester?.id,
                                                  )
                                                  ? "Pending..."
                                                  : "Accept",
                                          rejectText:
                                              _pendingFriendRequests.contains(
                                                    request.requester?.id,
                                                  )
                                                  ? "Pending..."
                                                  : "Reject",
                                          onAccept:
                                              _pendingFriendRequests.contains(
                                                    request.requester?.id,
                                                  )
                                                  ? null
                                                  : () => _handleFriendRequest(
                                                    request.requester?.id,
                                                    true,
                                                  ),
                                          onReject:
                                              _pendingFriendRequests.contains(
                                                    request.requester?.id,
                                                  )
                                                  ? null
                                                  : () => _handleFriendRequest(
                                                    request.requester?.id,
                                                    false,
                                                  ),
                                        );
                                      },
                                    );
                                  } else if (state is FriendRequestApproved) {
                                    if (_friendRequests.isEmpty) {
                                      return _buildEmptyState(
                                        'No friend requests',
                                      );
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
                                              request
                                                  .requester
                                                  ?.profilePictureUrl,
                                          acceptText:
                                              _pendingFriendRequests.contains(
                                                    request.requester?.id,
                                                  )
                                                  ? "Pending..."
                                                  : "Accept",
                                          rejectText:
                                              _pendingFriendRequests.contains(
                                                    request.requester?.id,
                                                  )
                                                  ? "Pending..."
                                                  : "Reject",
                                          onAccept:
                                              _pendingFriendRequests.contains(
                                                    request.requester?.id,
                                                  )
                                                  ? null
                                                  : () => _handleFriendRequest(
                                                    request.requester?.id,
                                                    true,
                                                  ),
                                          onReject:
                                              _pendingFriendRequests.contains(
                                                    request.requester?.id,
                                                  )
                                                  ? null
                                                  : () => _handleFriendRequest(
                                                    request.requester?.id,
                                                    false,
                                                  ),
                                        );
                                      },
                                    );
                                  } else if (state is FriendError) {
                                    if (state.message.contains('404')) {
                                      return _buildEmptyState(
                                        'No friend requests',
                                      );
                                    }
                                    return Center(child: Text(state.message));
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),

                          // Friends Tab
                          BlocProvider<FriendCubit>(
                            create: (context) => _friendsCubit,
                            child: BlocListener<FriendCubit, FriendState>(
                              bloc: _friendsCubit,
                              listener: (context, state) {
                                if (state is FriendRequestSent) {
                                  setState(() {
                                    _pendingFollowActions.clear();
                                  });
                                } else if (state is FriendUnfriended) {
                                  setState(() {
                                    _pendingUnfriendActions.clear();
                                  });
                                } else if (state is FriendError) {
                                  setState(() {
                                    _pendingFollowActions.clear();
                                    _pendingUnfriendActions.clear();
                                  });
                                }
                              },
                              child: BlocBuilder<FriendCubit, FriendState>(
                                bloc: _friendsCubit,
                                builder: (context, state) {
                                  if (state is FriendLoading &&
                                      _friends.isEmpty) {
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
                                              friend
                                                  .profilePicture['secure_url'],
                                          friend:
                                              _pendingUnfriendActions.contains(
                                                    friend.profileId,
                                                  )
                                                  ? "Pending..."
                                                  : "Unfriend",
                                          onPressed:
                                              _pendingUnfriendActions.contains(
                                                    friend.profileId,
                                                  )
                                                  ? null
                                                  : () => _handleUnfriend(
                                                    friend.profileId,
                                                  ),
                                        );
                                      },
                                    );
                                  } else if (state is FriendUnfriended) {
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
                                              friend
                                                  .profilePicture['secure_url'],
                                          friend:
                                              _pendingUnfriendActions.contains(
                                                    friend.profileId,
                                                  )
                                                  ? "Pending..."
                                                  : "Unfriend",
                                          onPressed:
                                              _pendingUnfriendActions.contains(
                                                    friend.profileId,
                                                  )
                                                  ? null
                                                  : () => _handleUnfriend(
                                                    friend.profileId,
                                                  ),
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
                            ),
                          ),

                          // Following Tab
                          BlocListener<FollowerCubit, FollowerState>(
                            bloc: widget.followerCubit,
                            listener: (context, state) {
                              if (state is FollowerActionSuccess) {
                                setState(() {
                                  _pendingUnfollowActions.clear();
                                });
                              } else if (state is FollowerError) {
                                setState(() {
                                  _pendingUnfollowActions.clear();
                                });
                              }
                            },
                            child: BlocBuilder<FollowerCubit, FollowerState>(
                              bloc: widget.followerCubit,
                              builder: (context, state) {
                                if (state is FollowerLoading &&
                                    _following.isEmpty) {
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
                                        friend:
                                            _pendingUnfollowActions.contains(
                                                  user.profileId,
                                                )
                                                ? "Pending..."
                                                : "Unfollow",
                                        onPressed:
                                            _pendingUnfollowActions.contains(
                                                  user.profileId,
                                                )
                                                ? null
                                                : () => _handleUnfollow(
                                                  user.profileId,
                                                ),
                                      );
                                    },
                                  );
                                } else if (state is FollowerActionSuccess) {
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
                                        friend:
                                            _pendingUnfollowActions.contains(
                                                  user.profileId,
                                                )
                                                ? "Pending..."
                                                : "Unfollow",
                                        onPressed:
                                            _pendingUnfollowActions.contains(
                                                  user.profileId,
                                                )
                                                ? null
                                                : () => _handleUnfollow(
                                                  user.profileId,
                                                ),
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
