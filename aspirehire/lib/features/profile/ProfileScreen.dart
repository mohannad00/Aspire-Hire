import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state_management/profile_cubit.dart';
import 'state_management/profile_state.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded ||
                state is ProfileUpdated ||
                state is ProfilePictureUpdated ||
                state is ResumeUploaded) {
              final profile = (state is ProfileLoaded
                  ? state.profile
                  : state is ProfileUpdated
                      ? state.profile
                      : state is ProfilePictureUpdated
                          ? state.profile
                          : (state as ResumeUploaded).profile);
              return ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  ProfileHeader(
                    avatarImage: profile.profilePicture?.secureUrl ??
                        'assets/avatar.png',
                    onEditPressed: () {
                      // Navigate to edit profile screen or show dialog
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
                      onAddLinkPressed: () {
                        // Handle add link logic
                      },
                      links: [], // No socialLinks in Profile model; adjust if added later
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Section(
                      title: "Skills",
                      children: profile.skills.map((skill) => ListTile(
                            leading: const CircleAvatar(
                              radius: 5,
                              backgroundImage: AssetImage('assets/Ellipse.png'),
                            ),
                            title: Text(skill),
                          )).toList(),
                    ),
                  ),
                ],
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else if (state is ProfilePictureDeleted) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Please load profile'));
          },
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
              decoration: const BoxDecoration(
                color: Color(0xFF013E5D),
              ),
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
            onBackgroundImageError: (_, __) =>
                const AssetImage('assets/avatar.png'),
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
              _buildInfoTile('assets/email.png', email),
              _buildInfoTile('assets/phone.png', phone),
              _buildInfoTile('assets/phone.png', dob),
              _buildInfoTile('assets/phone.png', gender),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String iconPath, String text) {
    return ListTile(
      leading: SizedBox(
        width: 20,
        height: 20,
        child: Image.asset(iconPath, fit: BoxFit.contain),
      ),
      title: Text(text),
    );
  }
}

class WebLinks extends StatelessWidget {
  final VoidCallback onAddLinkPressed;
  final List<String> links;

  const WebLinks({super.key, required this.onAddLinkPressed, required this.links});

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    "On the web",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(height: 1, width: 105, color: Colors.orange),
                ],
              ),
              ElevatedButton(
                onPressed: onAddLinkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 246, 251),
                  foregroundColor: const Color(0xFF013E5D),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                ),
                child: const Text("+ Add Link"),
              ),
            ],
          ),
          if (links.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: links.map((link) {
                String iconPath = 'assets/world.png';
                if (link.contains('linkedin')) {
                  iconPath = 'assets/Clip path group.png';
                } else if (link.contains('twitter') || link.contains('x.com')) {
                  iconPath = 'assets/twitter.png';
                }
                return IconButton(
                  icon: Image.asset(iconPath, width: 24, height: 24),
                  onPressed: () {
                    // Open link (use url_launcher package)
                  },
                );
              }).toList(),
            ),
          ],
        ],
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
          Container(
            height: 1,
            width: title.length * 8,
            color: Colors.orange,
          ),
          const SizedBox(height: 10),
          Column(children: children),
        ],
      ),
    );
  }
}