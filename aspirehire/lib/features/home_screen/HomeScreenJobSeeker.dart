// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/features/home_screen/components/HomeHeader.dart';
import 'package:aspirehire/features/home_screen/components/JobCard.dart';
import 'package:aspirehire/features/home_screen/components/MediaButtons.dart';
import 'package:aspirehire/features/home_screen/components/PostCard.dart';
import 'package:aspirehire/features/home_screen/components/PostJobButton.dart';
import 'package:aspirehire/features/profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:aspirehire/features/job_search/JobSearch.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';

class HomeScreenJobSeeker extends StatefulWidget {
  const HomeScreenJobSeeker({super.key});

  @override
  _HomeScreenJobSeekerState createState() => _HomeScreenJobSeekerState();
}

class _HomeScreenJobSeekerState extends State<HomeScreenJobSeeker> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(), // الهيدر
          const SizedBox(height: 10),
          const PostJobButton(), // زر "Post a Job!"
          const SizedBox(height: 10),
          const MediaButtons(), // أزرار الصور والفيديوهات والمستندات
          const SizedBox(height: 20),
          Container(height: 1, width: double.infinity, color: Colors.orange),
          const SizedBox(height: 20),
          const JobCard(),
          const JobCard(),
          const SizedBox(height: 20),
          const PostCard(), // المنشورات
          const PostCard(), // يمكن استدعاؤه عدة مرات لعرض منشورات متعددة
        ],
      ),
    ),
    const Center(child: Text("Search Page", style: TextStyle(fontSize: 24))),
    const Center(child: Text("List Page", style: TextStyle(fontSize: 24))),
    const Center(child: Text("Profile Page", style: TextStyle(fontSize: 24))),
  ];

  final List<String> _labels = ["Home", "Search", "List", "Profile"];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const JobSearch()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed the AppBar
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF013E5D), borderRadius: BorderRadius.circular(30)),
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
      onTap: () {
        _onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0, vertical: 10),
        decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF013E5D) : Colors.white, size: 28),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(label, style: const TextStyle(color: Color(0xFF013E5D), fontWeight: FontWeight.bold, fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }
}