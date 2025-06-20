import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
// Import your actual screens here
import '../../config/datasources/cache/shared_pref.dart';
import '../company_home_screen/company_home_screen.dart';
import '../company_profile/company_profile_screen.dart';
import '../seeker_profile/ProfileScreen.dart';
import '../menu_screen/MenuScreen.dart';

class CompanyHomeNavBar extends StatefulWidget {
  const CompanyHomeNavBar({super.key});

  @override
  _CompanyHomeNavBarState createState() => _CompanyHomeNavBarState();
}

class _CompanyHomeNavBarState extends State<CompanyHomeNavBar> {
  int _selectedIndex = 0;
  late PageController _pageController;
  final _animationDuration = const Duration(milliseconds: 250);
  bool _isNavBarVisible = true;
  Timer? _hideNavBarTimer;
  final String token = CacheHelper.getData('token') ?? '';
  final List<Widget> _screens = [
    CompanyHomeScreen(),
    CompanyProfileScreen(),
    MenuScreen(),
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
    _hideNavBarTimer = Timer(const Duration(seconds: 4), () {
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

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  void _onPageChanged(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  double getResponsiveFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double baseFontSize = 12.0;
    const double maxFontSize = 16.0;
    double fontSize = baseFontSize + (screenWidth - 320) * 0.01;
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
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _screens.length,
                itemBuilder: (context, index) {
                  return _screens[index];
                },
                physics: const ClampingScrollPhysics(),
              ),
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
                                children: List.generate(3, (index) {
                                  bool isSelected = _selectedIndex == index;
                                  List<String> labels = [
                                    "Home",
                                    "Profile",
                                    "Menu",
                                  ];
                                  List<IconData> icons = [
                                    Icons.home,
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
                                          curve: Curves.easeOutQuad,
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
