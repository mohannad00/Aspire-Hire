import 'package:aspirehire/features/community/test_follower_cubit.dart';
import 'package:flutter/material.dart';
import 'package:aspirehire/features/community/communityScreen.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:aspirehire/features/home_screen/HomeScreenJobSeeker.dart';
import 'package:aspirehire/features/job_search/JobSearch.dart';
import 'package:aspirehire/features/profile/ProfileScreen.dart';
import '../community/test.dart';
import '../my_applications/myApplicationScreen.dart';
import 'dart:async';

class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});

  @override
  _HomeNavBarState createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  int _selectedIndex = 0;
  late PageController _pageController;
  final _animationDuration = const Duration(milliseconds: 250);

  // Add for nav bar visibility
  bool _isNavBarVisible = true;
  Timer? _hideNavBarTimer;

  // List of screens for the bottom navigation bar
  final List<Widget> _screens = [
    HomeScreenJobSeeker(),
    JobSearch(),
    FollowerCubitTester(),
    ProfileScreen(),
    Myapplicationscreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedIndex,
      viewportFraction: 1.0,
    );
    _startHideNavBarTimer();
  }

  void _startHideNavBarTimer() {
    _hideNavBarTimer?.cancel();
    _hideNavBarTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _isNavBarVisible = false;
      });
    });
  }

  void _onUserInteraction() {
    if (!_isNavBarVisible) {
      setState(() {
        _isNavBarVisible = true;
      });
    }
    _startHideNavBarTimer();
  }

  // Handle bottom navigation bar item tap
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      // Use jumpToPage for immediate response with smooth transition
      _pageController.jumpToPage(index);
    }
  }

  // Handle page change when swiping
  void _onPageChanged(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Function to calculate responsive font size
  double getResponsiveFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Base font size for small screens (320px width)
    const double baseFontSize = 12.0;
    // Maximum font size for large screens
    const double maxFontSize = 16.0;
    // Calculate font size based on screen width
    double fontSize = baseFontSize + (screenWidth - 320) * 0.01;
    // Clamp the value between base and max
    return fontSize.clamp(baseFontSize, maxFontSize);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 350;
    final responsiveFontSize = getResponsiveFontSize(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onUserInteraction,
        onPanDown: (_) => _onUserInteraction(),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Optimized PageView with keepAlive
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _screens.length,
                itemBuilder: (context, index) {
                  return KeepAliveWrapper(child: _screens[index]);
                },
                physics: const ClampingScrollPhysics(), // Smoother scrolling
              ),

              // Bottom navigation bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: _isNavBarVisible ? Offset.zero : const Offset(0, 1),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isNavBarVisible ? 1.0 : 0.0,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.0001,
                        ),
                        child: Container(
                          height: screenHeight * 0.07,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.01,
                          ),
                          margin: EdgeInsets.all(screenWidth * 0.02),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  bool isSelected = _selectedIndex == index;
                                  List<String> labels = [
                                    "Home",
                                    "Search",
                                    "Community",
                                    "Profile",
                                    "My Apps",
                                  ];
                                  List<IconData> icons = [
                                    Icons.home,
                                    Icons.search,
                                    Icons.people,
                                    Icons.person,
                                    Icons.menu,
                                  ];

                                  return GestureDetector(
                                    onTap: () {
                                      _onUserInteraction();
                                      _onItemTapped(index);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01,
                                      ),
                                      child: Center(
                                        child: AnimatedContainer(
                                          duration: _animationDuration,
                                          curve:
                                              Curves
                                                  .easeOutQuad, // Smoother animation
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                isSelected
                                                    ? screenWidth * 0.04
                                                    : screenWidth * 0.02,
                                            vertical: screenHeight * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                icons[index],
                                                color:
                                                    isSelected
                                                        ? AppColors.primary
                                                        : Colors.white,
                                                size: responsiveFontSize * 1.75,
                                              ),
                                              if (isSelected)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: screenWidth * 0.02,
                                                  ),
                                                  child: Text(
                                                    isSmallScreen &&
                                                            labels[index]
                                                                    .length >
                                                                5
                                                        ? labels[index]
                                                            .split(' ')
                                                            .map(
                                                              (word) =>
                                                                  word[0]
                                                                      .toUpperCase(),
                                                            )
                                                            .join('')
                                                        : labels[index],
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          responsiveFontSize,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _hideNavBarTimer?.cancel();
    super.dispose();
  }
}

// Helper widget to maintain state of pages
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}