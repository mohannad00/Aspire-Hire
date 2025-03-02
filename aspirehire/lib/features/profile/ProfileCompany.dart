// ignore_for_file: file_names, library_private_types_in_public_api

//import 'package:aspirehire/ReusableComponent.dart';
import 'package:aspirehire/features/home_screen/HomeCompany.dart';
import 'package:aspirehire/features/profile/EditProfile.dart';
import 'package:flutter/material.dart';
import 'package:aspirehire/features/job_search/JobSearch.dart';

class ProfileCompany extends StatefulWidget {
  const ProfileCompany({super.key});

  @override
  State<ProfileCompany> createState() => _ProfileCompanyState();
}

class _ProfileCompanyState extends State<ProfileCompany> {
  int _selectedIndex = 3;

  final List<String> _labels = ["Home", "Search", "List", "Profile"];

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeCompany()),
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
  bool isPostsSelected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
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
                const Positioned(
                  top: 100,
                  left: 20,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(''),
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 330,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EditProfile()),
          );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "Dell Technologies Inc ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                              height: 1,
                              width: 220,
                              color: Colors.orange,
                            ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  

                  ListTile(
  leading: SizedBox(
    width: 20, // تحديد عرض الصورة
    height: 20, // تحديد ارتفاع الصورة
    child: Image.asset(
      'assets/phone.png', // مسار الصورة
      fit: BoxFit.contain, // ضمان ملاءمة الصورة داخل الحاوية
    ),
  ),
  title: const Text("+201000001100"),
),

ListTile(
  leading: SizedBox(
    width: 20, // تحديد عرض الصورة
    height: 20, // تحديد ارتفاع الصورة
    child: Image.asset(
      'assets/email.png', // مسار الصورة
      fit: BoxFit.contain, // ضمان ملاءمة الصورة داخل الحاوية
    ),
  ),
  title: const Text("delltechnologies@gmail.com"),
),
ListTile(
  leading: SizedBox(
    width: 20, // تحديد عرض الصورة
    height: 20, // تحديد ارتفاع الصورة
    child: Image.asset(
      'assets/location.png', // مسار الصورة
      fit: BoxFit.contain, // ضمان ملاءمة الصورة داخل الحاوية
    ),
  ),
  title: const Text("Egypt, Cairo"),
),
                ],
              ),
            ),
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("About company ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Container(
                      height: 1,
                      width: 147,
                      color: Colors.orange,
                    ),
                    const Text("Dell is a global technology leader, providing innovative computers, software, and IT solutions. Committed to excellence, Dell offers a dynamic work environment with opportunities for growth and development.")
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Container(
                      height: 1,
                      width: 147,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 8),

                    const Text(
              'Website',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'http://www.delitechnologyinc.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Company size',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '10,000+ Employee',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  isPostsSelected = true;
                });
              },
              child: Text(
                'Posts',
                style: TextStyle(
                  color: isPostsSelected ? const Color(0xFF013E5D) : Colors.grey,
                  fontSize: 16,
                  fontWeight: isPostsSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.21),
            TextButton(
              onPressed: () {
                setState(() {
                  isPostsSelected = false;
                });
              },
              child: Text(
                'Jobs',
                style: TextStyle(
                  color: isPostsSelected ? Colors.grey : const Color(0xFF013E5D),
                  fontSize: 16,
                  fontWeight: isPostsSelected ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
        padding:
            EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF013E5D) : Colors.white,
                size: 28),
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
