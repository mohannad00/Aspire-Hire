import 'package:flutter/material.dart';
import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import '../auth/login/LoginScreen.dart';
import '../job_post/PostJob.dart';
import '../company_job_posts/company_job_posts_screen.dart';
import '../people_search/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/company_profile/company_profile_cubit.dart';
import 'package:aspirehire/features/company_profile/company_profile_state.dart';
import 'package:aspirehire/core/models/Company.dart';
import 'package:aspirehire/core/utils/app_colors.dart';

class CompanyMenuScreen extends StatefulWidget {
  const CompanyMenuScreen({Key? key}) : super(key: key);

  @override
  State<CompanyMenuScreen> createState() => _CompanyMenuScreenState();
}

class _CompanyMenuScreenState extends State<CompanyMenuScreen> {
  Company? _company;
  bool _profileRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_profileRequested) {
      _fetchProfile();
      _profileRequested = true;
    }
  }

  Future<void> _fetchProfile() async {
    final token = await CacheHelper.getData('token');
    if (token != null) {
      context.read<CompanyProfileCubit>().profile(token);
    }
  }

  void _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Log out'),
            content: const Text('Do you really want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    if (shouldLogout == true) {
      await CacheHelper.removeKey('token');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _viewMyJobPosts(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CompanyJobPostsScreen()));
  }

  void _viewPostJob(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PostJob(
              onNavigateToHome: () {
                Navigator.pop(context);
              },
            ),
      ),
    );
  }

  void _viewPeopleSearch(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.work,
        label: 'My Job Posts',
        color: const Color(0xFF013E5D),
        onTap: () => _viewMyJobPosts(context),
      ),
      _MenuItem(
        icon: Icons.post_add,
        label: 'Post New Job',
        color: const Color(0xFF013E5D),
        onTap: () => _viewPostJob(context),
      ),
      _MenuItem(
        icon: Icons.people,
        label: 'Search People',
        color: const Color(0xFF013E5D),
        onTap: () => _viewPeopleSearch(context),
      ),
      _MenuItem(
        icon: Icons.analytics,
        label: 'Analytics',
        color: const Color(0xFF013E5D),
        onTap: () {
          // TODO: Implement analytics screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Analytics feature coming soon!'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
      _MenuItem(
        icon: Icons.settings,
        label: 'Settings',
        color: const Color(0xFF013E5D),
        onTap: () {
          // TODO: Implement settings screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Settings feature coming soon!'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
      _MenuItem(
        icon: Icons.logout,
        label: 'Log out',
        color: Colors.red,
        onTap: () => _logout(context),
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF044463), Color.fromARGB(255, 120, 125, 129)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with avatar and greeting
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: BlocBuilder<CompanyProfileCubit, CompanyProfileState>(
                    builder: (context, state) {
                      String companyName = '';
                      String? avatarUrl;
                      if (state is CompanyProfileLoaded) {
                        final company = state.data.user;
                        companyName = company.companyName;
                        avatarUrl = company.profilePicture?.secureUrl;
                      }
                      return Row(
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child:
                                avatarUrl != null
                                    ? _CompanyImageWithLoader(url: avatarUrl)
                                    : const CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.business,
                                        size: 32,
                                        color: Color(0xFF044463),
                                      ),
                                    ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  companyName.isNotEmpty
                                      ? 'Hello, $companyName!'
                                      : 'Hello, Company!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Manage your company and job posts',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Menu grid
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(24),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      children:
                          items
                              .map((item) => _AnimatedMenuCard(item: item))
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _AnimatedMenuCard extends StatefulWidget {
  final _MenuItem item;
  const _AnimatedMenuCard({required this.item});

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.item.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          elevation: 8,
          shadowColor: widget.item.color.withOpacity(0.2),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.item.icon, color: widget.item.color, size: 44),
                const SizedBox(height: 18),
                Text(
                  widget.item.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.item.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget to show a loader while the network image is loading
class _CompanyImageWithLoader extends StatefulWidget {
  final String url;
  const _CompanyImageWithLoader({required this.url});

  @override
  State<_CompanyImageWithLoader> createState() =>
      _CompanyImageWithLoaderState();
}

class _CompanyImageWithLoaderState extends State<_CompanyImageWithLoader> {
  bool _loading = true;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const CircleAvatar(
        radius: 32,
        backgroundColor: Colors.white,
        child: Icon(Icons.business, size: 32, color: Color(0xFF044463)),
      );
    }
    return ClipOval(
      child: SizedBox(
        width: 64,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              widget.url,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  if (_loading) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _loading = false);
                    });
                  }
                  return child;
                } else {
                  if (!_loading) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _loading = true);
                    });
                  }
                  return const SizedBox.shrink();
                }
              },
              errorBuilder: (context, error, stackTrace) {
                if (!_error) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _error = true);
                  });
                }
                return const SizedBox.shrink();
              },
            ),
            if (_loading)
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
      ),
    );
  }
}
