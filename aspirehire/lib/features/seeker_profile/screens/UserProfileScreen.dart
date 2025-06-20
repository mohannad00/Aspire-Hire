import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state_management/user_profile_cubit.dart';
import '../state_management/user_profile_state.dart';
import '../../../core/models/UserProfile.dart';
import '../../../core/models/Feed.dart';
import '../../../config/datasources/cache/shared_pref.dart';
import '../components/ProfileHeader.dart';
import '../components/AboutTab.dart';
import '../components/PostsTab.dart';
import '../components/ProfileSkeleton.dart';
import '../components/ProfileErrorWidget.dart';
import '../state_management/profile_cubit.dart';
import '../state_management/profile_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String? userName;

  const UserProfileScreen({Key? key, required this.userId, this.userName})
    : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UserProfileCubit _userProfileCubit;
  late ProfileCubit _currentUserProfileCubit;
  String? token;
  String? _currentUserId;

  // Refresh state
  bool _isRefreshing = false;

  // Loading states
  bool _profileLoaded = false;
  bool _currentUserLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _userProfileCubit = UserProfileCubit();
    _currentUserProfileCubit = ProfileCubit();
    _loadUserProfile();
    _loadCurrentUserProfile();
  }

  Future<void> _loadUserProfile() async {
    token = await _getToken();
    if (token != null) {
      _userProfileCubit.getUserProfile(token!, widget.userId);
    }
  }

  Future<void> _loadCurrentUserProfile() async {
    token = await _getToken();
    if (token != null) {
      _currentUserProfileCubit.getProfile(token!);
    }
  }

  Future<String?> _getToken() async {
    try {
      return await CacheHelper.getData('token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Handle refresh
  Future<void> _handleRefresh() async {
    if (token != null) {
      setState(() {
        _isRefreshing = true;
        _profileLoaded = false;
        _currentUserLoaded = false;
      });

      // Clear all caches
      _userProfileCubit.clearUserCache(widget.userId, token!);

      // Reload current user profile to get fresh user ID
      await _currentUserProfileCubit.getProfile(token!);

      // Reload user profile
      await _userProfileCubit.getUserProfile(token!, widget.userId);

      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userProfileCubit.close();
    _currentUserProfileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _userProfileCubit),
        BlocProvider.value(value: _currentUserProfileCubit),
      ],
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, profileState) {
          if (profileState is ProfileLoaded) {
            setState(() {
              _currentUserId = profileState.profile.profileId;
              _currentUserLoaded = true;
            });
          }
        },
        child: BlocListener<UserProfileCubit, UserProfileState>(
          listener: (context, userProfileState) {
            if (userProfileState is UserProfileLoaded) {
              setState(() {
                _profileLoaded = true;
              });
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, state) {
                  // Show skeleton until both profile and current user data are loaded
                  if (!_profileLoaded || !_currentUserLoaded) {
                    return ProfileSkeleton(onRefresh: _handleRefresh);
                  }

                  if (state is UserProfileLoading) {
                    return ProfileSkeleton(onRefresh: _handleRefresh);
                  } else if (state is UserProfileLoaded) {
                    return _buildProfileContent(state.data);
                  } else if (state is UserProfileError) {
                    return ProfileErrorWidget(
                      message: state.message,
                      onRetry: _loadUserProfile,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserProfileData data) {
    final user = data.user;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Profile Header
                ProfileHeader(
                  user: user,
                  isCurrentUser: _currentUserId == user.profileId,
                ),

                // Web Links Section (read-only, no add/edit button)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 12,
                  ),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'On the web',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      height: 2,
                                      width: 110,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              if (user.github?.isNotEmpty == true)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final controller =
                                          WebViewController()
                                            ..setJavaScriptMode(
                                              JavaScriptMode.unrestricted,
                                            )
                                            ..loadRequest(
                                              Uri.parse(user.github!),
                                            );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => Scaffold(
                                                backgroundColor: Colors.white,
                                                appBar: AppBar(
                                                  title: const Text(
                                                    'GitHub',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                body: WebViewWidget(
                                                  controller: controller,
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.code,
                                      color: Colors.white,
                                    ),
                                    label: const Text('GitHub'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF24292F),
                                      foregroundColor: Colors.white,
                                      shape: StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              if (user.twitter?.isNotEmpty == true)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final controller =
                                        WebViewController()
                                          ..setJavaScriptMode(
                                            JavaScriptMode.unrestricted,
                                          )
                                          ..loadRequest(
                                            Uri.parse(user.twitter!),
                                          );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => Scaffold(
                                              backgroundColor: Colors.white,
                                              appBar: AppBar(
                                                title: const Text(
                                                  'X',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              body: WebViewWidget(
                                                controller: controller,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.alternate_email,
                                    color: Colors.white,
                                  ),
                                  label: const Text('X'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1DA1F2),
                                    foregroundColor: Colors.white,
                                    shape: StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF013E5D),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF013E5D),
                    tabs: const [Tab(text: 'About'), Tab(text: 'Posts')],
                  ),
                ),

                // Tab Content
                Container(
                  height:
                      MediaQuery.of(context).size.height -
                      300, // Adjust height for scrollable content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AboutTab(user: user),
                      PostsTab(
                        basicPosts: data.posts,
                        isRefreshing: _isRefreshing,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Refresh overlay
        if (_isRefreshing)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Refreshing profile...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
