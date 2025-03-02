import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/home_screen/components/HomeHeader.dart';
import 'package:aspirehire/features/home_screen/components/JobCard.dart';
import 'package:aspirehire/features/home_screen/components/MediaButtons.dart';
import 'package:aspirehire/features/home_screen/components/PostCard.dart';
import 'package:aspirehire/features/home_screen/components/PostJobButton.dart';
import 'package:aspirehire/features/profile/ProfileScreen.dart';
import 'package:aspirehire/features/job_search/JobSearch.dart';

import '../../config/datasources/cache/shared_pref.dart';
import '../profile/state_management/profile_cubit.dart';
import '../profile/state_management/profile_state.dart';

class HomeScreenJobSeeker extends StatefulWidget {
  const HomeScreenJobSeeker({super.key});

  @override
  _HomeScreenJobSeekerState createState() => _HomeScreenJobSeekerState();
}

class _HomeScreenJobSeekerState extends State<HomeScreenJobSeeker> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Fetch profile data when the screen is initialized
  }

  Future<void> _fetchProfile() async {
    // Retrieve the token from SharedPreferences
    final token = await CacheHelper.getData('token');
    if (token != null) {
      // Fetch profile data
      context.read<ProfileCubit>().getProfile(token);
    }
  }

  final List<Widget> _pages = [
    const HomePage(), // Home Page
    const Center(child: Text("Search Page", style: TextStyle(fontSize: 24))),
    const Center(child: Text("List Page", style: TextStyle(fontSize: 24))),
    const Center(child: Text("Profile Page", style: TextStyle(fontSize: 24))),
  ];

  final List<String> _labels = ["Home", "Search", "List", "Profile"];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const JobSearch()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF013E5D),
          borderRadius: BorderRadius.circular(20),
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
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 0,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF013E5D) : Colors.white,
              size: 28,
            ),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(
                  firstName: state.profile.firstName,
                  lastName: state.profile.lastName,
                  profilePicture: state.profile.profilePicture!.secureUrl,
                ), // Dynamic HomeHeader
                const SizedBox(height: 10),
                const PostJobButton(), // زر "Post a Job!"
                const SizedBox(height: 10),
                const MediaButtons(), // أزرار الصور والفيديوهات والمستندات
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.orange,
                ),
                const SizedBox(height: 20),
                // Horizontal Scrollable JobCard Section
                SizedBox(
                  height: 92, // Set a fixed height for the horizontal ListView
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      JobCard(
                        jobTitle: 'Web Designer',
                        company: 'hp',
                        jobType: 'Part-time',
                        location: 'Egypt, Cairo',
                        logoPath: 'assets/logo.png',
                        onClosePressed: null,
                      ),
                      SizedBox(width: 10), // Add spacing between cards
                      JobCard(
                        jobTitle: 'Graphic Designer',
                        company: 'Dell',
                        jobType: 'Full-time',
                        location: 'Egypt, Alexandria',
                        logoPath: 'assets/logo.png',
                        onClosePressed: null,
                      ),
                      SizedBox(width: 10), // Add spacing between cards
                      JobCard(
                        jobTitle: 'UI/UX Designer',
                        company: 'Google',
                        jobType: 'Contract',
                        location: 'Egypt, Giza',
                        logoPath: 'assets/logo.png',
                        onClosePressed: null,
                      ),
                      // Add more JobCard widgets as needed
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const PostCard(
                  jobTitle: 'Mohannad Hossam',
                  company: 'Dell',
                  jobType: 'Full-time',
                  location: 'Egypt, Cairo',
                  description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
"""                ), // المنشورات
                const PostCard(
                  jobTitle: 'Web Designer',
                  company: 'hp',
                  jobType: 'Part-time',
                  location: 'Egypt, Cairo',
                  description:
                      'Looking for a skilled Web Designer to join our team part-time. Must be located in Cairo, Egypt.',
                ), // يمكن استدعاؤه عدة مرات لعرض منشورات متعددة
              ],
            ),
          );
        } else if (state is ProfileError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Initial State'));
        }
      },
    );
  }
}