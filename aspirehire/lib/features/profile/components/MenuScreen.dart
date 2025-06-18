import 'package:flutter/material.dart';
import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import '../../applications/ui/applications_screen.dart';
import '../../auth/login/LoginScreen.dart';
import '../../job_search/JobSearch.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.search,
        label: 'Job Search',
        color: Color(0xFF1976D2),
        onTap: () => _viewJobSearch(context),
      ),
      _MenuItem(
        icon: Icons.assignment_turned_in,
        label: 'View my job applications',
        color: const Color(0xFF013E5D),
        onTap: () => _viewApplications(context),
      ),
      _MenuItem(
        icon: Icons.logout,
        label: 'Log out',
        color: Colors.red,
        onTap: () => _logout(context),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF044463), // Dark blue
                child: const Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        padding: const EdgeInsets.all(24),
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        children: items.map((item) => _MenuCard(item: item)).toList(),
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

class _MenuCard extends StatelessWidget {
  final _MenuItem item;
  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: item.color, size: 40),
              const SizedBox(height: 16),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
