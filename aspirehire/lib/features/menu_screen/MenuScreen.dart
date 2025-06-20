import 'package:flutter/material.dart';
import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import '../applications/ui/applications_screen.dart';
import '../auth/login/LoginScreen.dart';
import '../job_search/JobSearch.dart';
import '../ats_evaluate/screens/ats_input_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ats_evaluate/state_management/ats_evaluate_cubit.dart';
import '../generate_summary/screens/generate_summary_selection_screen.dart';
import '../generate_summary/state_management/generate_summary_cubit.dart';
import '../generate_cv/screens/generate_cv_selection_screen.dart';
import '../generate_cv/state_management/generate_cv_cubit.dart';
import 'package:aspirehire/features/seeker_profile/state_management/profile_cubit.dart';
import 'package:aspirehire/features/seeker_profile/state_management/profile_state.dart';
import 'package:aspirehire/core/models/GetProfile.dart';
import 'package:aspirehire/core/utils/app_colors.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Profile? _profile;
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
      context.read<ProfileCubit>().getProfile(token);
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

  void _viewApplications(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ApplicationsScreen()));
  }

  void _viewJobSearch(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const JobSearch()));
  }

  void _viewATSCheck(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => ATSEvaluateCubit(),
              child: const ATSInputScreen(),
            ),
      ),
    );
  }

  void _viewGenerateSummary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => GenerateSummaryCubit(),
              child: const GenerateSummarySelectionScreen(),
            ),
      ),
    );
  }

  void _viewGenerateCv(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => GenerateCvCubit(),
              child: const GenerateCvSelectionScreen(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.assignment_turned_in,
        label: 'View my job applications',
        color: const Color(0xFF013E5D),
        onTap: () => _viewApplications(context),
      ),
      _MenuItem(
        icon: Icons.analytics,
        label: 'ATS Resume Check',
        color: const Color(0xFF013E5D),
        onTap: () => _viewATSCheck(context),
      ),
      _MenuItem(
        icon: Icons.description,
        label: 'Generate Summary',
        color: const Color(0xFF013E5D),
        onTap: () => _viewGenerateSummary(context),
      ),
      _MenuItem(
        icon: Icons.picture_as_pdf,
        label: 'Generate CV',
        color: const Color(0xFF013E5D),
        onTap: () => _viewGenerateCv(context),
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
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      String name = '';
                      String? avatarUrl;
                      if (state is ProfileLoaded ||
                          state is ProfileUpdated ||
                          state is ProfilePictureUpdated ||
                          state is ResumeUploaded) {
                        final profile =
                            (state is ProfileLoaded
                                ? state.profile
                                : state is ProfileUpdated
                                ? state.profile
                                : state is ProfilePictureUpdated
                                ? state.profile
                                : (state as ResumeUploaded).profile);
                        name = '${profile.firstName} ${profile.lastName}';
                        avatarUrl = profile.profilePicture?.secureUrl;
                      }
                      return Row(
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child:
                                avatarUrl != null
                                    ? _ProfileImageWithLoader(url: avatarUrl)
                                    : const CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Colors.white,
                                    ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name.isNotEmpty ? 'Hello, $name!' : 'Hello!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'What would you like to do today?',
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
class _ProfileImageWithLoader extends StatefulWidget {
  final String url;
  const _ProfileImageWithLoader({required this.url});

  @override
  State<_ProfileImageWithLoader> createState() =>
      _ProfileImageWithLoaderState();
}

class _ProfileImageWithLoaderState extends State<_ProfileImageWithLoader> {
  bool _loading = true;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const CircleAvatar(
        radius: 32,
        backgroundImage: AssetImage('assets/avatar.png'),
        backgroundColor: Colors.white,
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
