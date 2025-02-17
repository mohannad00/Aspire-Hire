// ignore_for_file: file_names

import 'package:aspirehire/features/profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:aspirehire/features/home_screen/HomeScreen.dart';
import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';
import 'package:percent_indicator/percent_indicator.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({super.key});

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  int _selectedIndex = 1; // تحديد Search كافتراضي

  final List<String> _labels = ["Home", "Search", "List", "Profile"];

  void _onItemTapped(int index) {
    if (index == 0) {
      // عند الضغط على Home، الانتقال إلى HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } 
     else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
    else {
      // تحديث التحديد لباقي الأيقونات مع الإبقاء على Search كما هو
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: ReusableComponents.reusableBackButton(
          context: context,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChoosingRole()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Search Container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF013E5D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Job Search',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey, size: 35),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'What are you looking for?',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.tune, color: Color(0xFF013E5D)),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text("All 100 jobs found", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 25),
            Row(
              children: [
                _buildJobCard(),
                const SizedBox(width: 25),
                _buildJobCard(),
              ],
            ),
          ],
        ),
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

  Widget _buildJobCard() {
    return Container(
      width: 170,
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
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(''), // استبدل بمسار الصورة
              ),
              Column(
                children: [
                  const SizedBox(height: 4),
                  CircularPercentIndicator(
                    radius: 18,
                    lineWidth: 4,
                    percent: 0.8,
                    center: const Text("80%", style: TextStyle(fontSize: 10)),
                    progressColor: Colors.orange,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Fulltime",
            style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          const Text("Web Designer.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("700-800 EGP / hour", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text("Company: DELL", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                child: ReusableComponents.reusableButton(
                  title: 'Apply',
                  fontSize: 15,
                  backgroundColor: const Color(0xFF013E5D),
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}