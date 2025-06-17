import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/AddLinksScreen.dart';
import 'state_management/profile_cubit.dart';
import 'state_management/profile_state.dart';
import 'EditProfile.dart';
import 'EditSkills.dart';
import 'EditEducation.dart';
import 'EditExperience.dart';
import '../skill_test/skill_selection_screen.dart';
import '../../core/models/GetProfile.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  String? _token;
  bool _isInitialized = false;
  bool _skillsExpanded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfileIfNeeded();
  }

  Future<void> _loadToken() async {
    _token = await CacheHelper.getData('token');
    if (_token != null && !_isInitialized) {
      _isInitialized = true;
      _loadProfile();
    }
  }

  void _loadProfileIfNeeded() {
    if (_token != null) {
      _loadProfile();
    }
  }

  void _loadProfile() {
    if (_token != null) {
      context.read<ProfileCubit>().getProfile(_token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded ||
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
                return ListView(
                  padding: const EdgeInsets.only(bottom: 10),
                  children: [
                    ProfileHeader(
                      avatarImage:
                          profile.profilePicture?.secureUrl ??
                          'assets/avatar.png',
                      onEditPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ),
                        ).then((_) {
                          // Refresh profile after returning from edit screen
                          _loadProfile();
                        });
                      },
                    ),
                    ProfileInfo(
                      name: '${profile.firstName} ${profile.lastName}',
                      username: profile.username,
                      phone: profile.phone,
                      email: profile.email,
                      dob: profile.dob,
                      gender: profile.gender,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: WebLinks(
                        github: profile.github,
                        twitter: profile.twitter,
                        onAddLinkPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AddLinksScreen(
                                    github: profile.github,
                                    twitter: profile.twitter,
                                  ),
                            ),
                          );
                          if (result == true) _loadProfile();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Skills Section with Edit Icon
                    Center(
                      child: Container(
                        width: 400,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Skills",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (profile.skills.length > 5)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _skillsExpanded = !_skillsExpanded;
                                          });
                                        },
                                        child: Text(
                                          _skillsExpanded
                                              ? 'Show Less'
                                              : 'Show More',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const EditSkills(),
                                          ),
                                        ).then((_) {
                                          // Refresh profile after returning from edit screen
                                          _loadProfile();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const SkillSelectionScreen(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.verified,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 1,
                              width: 50,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 10),
                            if (profile.skills.isEmpty)
                              const Text(
                                'No skills added yet. Tap the edit icon to add skills.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              )
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    _skillsExpanded
                                        ? profile.skills
                                            .toList()
                                            .where((skill) => skill.verified)
                                            .toList()
                                            .followedBy(
                                              profile.skills
                                                  .toList()
                                                  .where(
                                                    (skill) => !skill.verified,
                                                  )
                                                  .toList(),
                                            )
                                            .map(
                                              (skill) => _buildSkillChip(skill),
                                            )
                                            .toList()
                                        : profile.skills
                                            .toList()
                                            .where((skill) => skill.verified)
                                            .toList()
                                            .followedBy(
                                              profile.skills
                                                  .toList()
                                                  .where(
                                                    (skill) => !skill.verified,
                                                  )
                                                  .toList(),
                                            )
                                            .take(5)
                                            .map(
                                              (skill) => _buildSkillChip(skill),
                                            )
                                            .toList(),
                              ),
                            if (profile.skills.length > 5 && !_skillsExpanded)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '+${profile.skills.length - 5} more skills',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Education Section with Edit Icon
                    Center(
                      child: Container(
                        width: 400,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Education",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const EditEducation(),
                                      ),
                                    ).then((_) {
                                      // Refresh profile after returning from edit screen
                                      _loadProfile();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 1,
                              width: 80,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 10),
                            if (profile.education.isEmpty)
                              const Text(
                                'No education added yet. Tap the edit icon to add education.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              )
                            else
                              Column(
                                children:
                                    profile.education
                                        .take(3)
                                        .map(
                                          (edu) => ListTile(
                                            leading: const Icon(
                                              Icons.school,
                                              color: AppColors.primary,
                                            ),
                                            title: Text(
                                              edu.degree ?? 'No degree',
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (edu.institution != null)
                                                  Text(
                                                    edu.institution!,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                if (edu.location != null)
                                                  Text(
                                                    edu.location!,
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        )
                                        .toList(),
                              ),
                            if (profile.education.length > 3)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '+${profile.education.length - 3} more entries',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Experience Section with Edit Icon
                    Center(
                      child: Container(
                        width: 400,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Experience",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const EditExperience(),
                                      ),
                                    ).then((_) {
                                      // Refresh profile after returning from edit screen
                                      _loadProfile();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 1,
                              width: 90,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 10),
                            if (profile.experience.isEmpty)
                              const Text(
                                'No experience added yet. Tap the edit icon to add experience.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              )
                            else
                              Column(
                                children:
                                    profile.experience
                                        .take(3)
                                        .map(
                                          (exp) => ListTile(
                                            leading: const Icon(
                                              Icons.work,
                                              color: AppColors.primary,
                                            ),
                                            title: Text(
                                              exp.title ?? 'No title',
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (exp.company != null)
                                                  Text(
                                                    exp.company!,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                if (exp.duration != null)
                                                  Text(
                                                    _formatDuration(
                                                      exp.duration!,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        )
                                        .toList(),
                              ),
                            if (profile.experience.length > 3)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '+${profile.experience.length - 3} more entries',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfilePictureDeleted) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('Please load profile'));
            },
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String avatarImage;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    super.key,
    required this.avatarImage,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(color: Color(0xFF013E5D)),
            ),
            Container(
              height: 55,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 100,
          left: 20,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(avatarImage),
            onBackgroundImageError:
                (_, __) => const AssetImage('assets/avatar.png'),
          ),
        ),
        Positioned(
          top: 120,
          right: 20,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.grey,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange, size: 25),
              onPressed: onEditPressed,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String name;
  final String username;
  final String phone;
  final String email;
  final String dob;
  final String gender;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.dob,
    required this.gender,
  });

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Not specified';

    try {
      final DateTime date = DateTime.parse(dateString);
      final List<String> months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      // If parsing fails, return the original string
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '@$username',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildInfoTile(CupertinoIcons.mail, email),
              _buildInfoTile(CupertinoIcons.phone, phone),
              _buildInfoTile(CupertinoIcons.calendar, _formatDate(dob)),
              _buildInfoTile(CupertinoIcons.person, gender),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(text),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class WebLinks extends StatelessWidget {
  final String? github;
  final String? twitter;
  final VoidCallback onAddLinkPressed;

  const WebLinks({
    super.key,
    this.github,
    this.twitter,
    required this.onAddLinkPressed,
  });

  void _openWebView(BuildContext context, String url, String title) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "We are now on Hiro App",
                        style: TextStyle(color: Colors.black , fontSize: 16),
                      ),
                    ),
                    Expanded(child: WebViewWidget(controller: controller)),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Container(height: 2, width: 110, color: Colors.orange),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onAddLinkPressed,
                    icon: const Icon(Icons.add_link),
                    label: const Text('Add Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF013E5D),
                      foregroundColor: Colors.white,
                      shape: StadiumBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (github?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton.icon(
                        onPressed:
                            () => _openWebView(context, github!, 'GitHub'),
                        icon: const Icon(Icons.code, color: Colors.white),
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
                  if (twitter?.isNotEmpty == true)
                    ElevatedButton.icon(
                      onPressed: () => _openWebView(context, twitter!, 'X'),
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
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const Section({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(height: 1, width: title.length * 8, color: Colors.orange),
          const SizedBox(height: 10),
          Column(children: children),
        ],
      ),
    );
  }
}

Widget _buildSkillChip(Skill skill) {
  return Stack(
    children: [
      Chip(
        label: Text(skill.skill),
        backgroundColor: AppColors.primary.withOpacity(0.1),
        side:
            skill.verified
                ? const BorderSide(color: Colors.amber, width: 2)
                : const BorderSide(color: Colors.transparent, width: 0),
      ),
      if (skill.verified)
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.verified, color: Colors.white, size: 12),
          ),
        ),
    ],
  );
}

String _formatDuration(ExperienceDuration duration) {
  try {
    final fromDate = DateTime.parse(duration.from);
    final toDate = DateTime.parse(duration.to);

    final fromMonth = _getMonthName(fromDate.month);
    final toMonth = _getMonthName(toDate.month);

    return '$fromMonth ${fromDate.year} - $toMonth ${toDate.year}';
  } catch (e) {
    return 'Duration not specified';
  }
}

String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
