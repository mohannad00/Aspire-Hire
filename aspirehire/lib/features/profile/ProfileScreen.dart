import 'dart:ui';
import 'package:flutter/material.dart';

import '../home_screen/HomeScreenJobSeeker.dart';
import '../job_search/JobSearch.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

  final List<String> _labels = ["Home", "Search", "List", "Profile"];

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreenJobSeeker()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JobSearch()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20), // Add padding at the bottom
        children: [
          const ProfileHeader(
            avatarImage: 'assets/avatar.png',
          ),
          const ProfileInfo(
            name: "Mustafa Mahmoud",
            jobTitle: "Senior Fullstack Developer",
            phone: "+201000001100",
            email: "MustafaMahmoud@gmail.com",
            location: "Egypt, Cairo",
          ),
          const SizedBox(height: 20),
          Center(
            child: WebLinks(
              onAddLinkPressed: () {
                // Handle add link button press
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Section(
              title: "Experiences",
              children: const [
                ListTile(
                  leading: CircleAvatar(
                    radius: 5,
                    backgroundImage: AssetImage('assets/Ellipse.png'),
                  ),
                  title: Text("Senior Fullstack Developer - Xceed"),
                  subtitle: Text("May, 2023 - Currently"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 5,
                    backgroundImage: AssetImage('assets/Ellipse.png'),
                  ),
                  title: Text("Senior Fullstack Developer - Oracle"),
                  subtitle: Text("March 2021 - May 2023"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Section(
              title: "Education",
              children: const [
                ListTile(
                  leading: CircleAvatar(
                    radius: 5,
                    backgroundImage: AssetImage('assets/Ellipse.png'),
                  ),
                  title: Text("Computer Science"),
                  subtitle: Text("Cairo University - Egypt"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Section(
              title: "Skills",
              children: const [
                ListTile(
                  leading: CircleAvatar(
                    radius: 5,
                    backgroundImage: AssetImage('assets/Ellipse.png'),
                  ),
                  title: Text("Flutter"),
                  subtitle: Text("Advanced"),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF013E5D),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, _labels[0], 0),
            _buildNavItem(Icons.search, _labels[1], 1),
            _buildNavItem(Icons.list, _labels[2], 2),
            _buildNavItem(Icons.person, _labels[3], 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF013E5D) : Colors.white, size: 28),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF013E5D),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/*

*/


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
        Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0xFF013E5D),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 20,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(avatarImage),
          ),
        ),
        Positioned(
          top: 120,
          left: 330,
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: onEditPressed,
          ),
        ),
      ],
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String phone;
  final String email;
  final String location;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.phone,
    required this.email,
    required this.location,
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildInfoTile('assets/business.png', jobTitle),
              _buildInfoTile('assets/phone.png', phone),
              _buildInfoTile('assets/email.png', email),
              _buildInfoTile('assets/location.png', location),
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

  const WebLinks({super.key, required this.onAddLinkPressed});

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
                  Container(
                    height: 1,
                    width: 105,
                    color: Colors.orange,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onAddLinkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 246, 251),
                  foregroundColor: const Color(0xFF013E5D),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text("+ Add Link"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Image.asset('assets/Clip path group.png', width: 24, height: 24),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset('assets/twitter.png', width: 24, height: 24),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset('assets/world.png', width: 24, height: 24),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const Section({
    super.key,
    required this.title,
    required this.children,
  });

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
            width: title.length * 8, // Dynamic width based on title length
            color: Colors.orange,
          ),
          const SizedBox(height: 10),
          Column(children: children),
        ],
      ),
    );
  }
}


