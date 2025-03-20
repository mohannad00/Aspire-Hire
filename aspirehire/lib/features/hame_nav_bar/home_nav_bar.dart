// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:aspirehire/features/home_screen/HomeScreenJobSeeker.dart';
import 'package:aspirehire/features/job_search/JobSearch.dart';
import 'package:aspirehire/features/profile/ProfileScreen.dart';

class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});

  @override
  _HomeNavBarState createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  int _selectedIndex = 0;

  // List of screens for the bottom navigation bar
  final List<Widget> _screens = [
    const HomeScreenJobSeeker(),
    const JobSearch(),
    const Dump(),
    const ProfileScreen(),
  ];

  // PageController for swipe navigation
  final PageController _pageController = PageController();

  // Handle bottom navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Animate to the selected page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Handle page change when swiping
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make the background transparent
      body: Stack(
        children: [
          // PageView for swipe navigation
          PageView(
            controller: _pageController, // Assign the PageController
            onPageChanged: _onPageChanged, // Handle page changes
            children: _screens, // Use the same screens as the bottom nav bar
          ),

          // Transparent bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
              child: Container(
                height: 60, // Exact height as CustomNavBar
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ), // Exact padding
                margin: const EdgeInsets.all(10), // Exact margin
                decoration: BoxDecoration(
                  color: AppColors.primary, // Slightly transparent background
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // Exact border radius
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(4, (index) {
                      bool isSelected = _selectedIndex == index;
                      List<String> labels = [
                        "Home",
                        "Search",
                        "Community",
                        "Profile",
                      ];
                      List<IconData> icons = [
                        Icons.home,
                        Icons.search,
                        Icons.people,
                        Icons.person,
                      ];

                      return GestureDetector(
                        onTap: () => _onItemTapped(index),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSelected ? 16 : 0, // Exact horizontal padding
                              vertical: 10, // Exact vertical padding
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                30,
                              ), // Exact border radius for selected item
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min, // Ensure the Row takes minimum space
                              children: [
                                Icon(
                                  icons[index],
                                  color: isSelected ? AppColors.primary : Colors.white,
                                  size: 28, // Exact icon size
                                ),
                                if (isSelected)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                    ), // Exact padding between icon and label
                                    child: Text(
                                      labels[index],
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16, // Exact font size
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the PageController when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }
}

class Dump extends StatelessWidget {
  const Dump({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('This is a dump screen'),
          ],
        ),
      ),
    );
  }
}