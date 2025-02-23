// ignore_for_file: file_names, library_private_types_in_public_api

//import 'package:aspirehire/ReusableComponent.dart';
import 'package:flutter/material.dart';
import 'package:aspirehire/features/job_search/JobSearch.dart';
import 'package:aspirehire/features/home_screen/HomeScreenJobSeeker.dart';

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
                Positioned(
                  top: 100,
                  left: 20,
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(''),
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 330,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Mustafa Mahmoud",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
      'assets/business.png', // مسار الصورة
      fit: BoxFit.contain, // ضمان ملاءمة الصورة داخل الحاوية
    ),
  ),
  title: const Text("Senior Fullstack Developer"),
),
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
  title: const Text("MustafaMahmoud@gmail.com"),
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
                            Text("On the web",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Container(
                              height: 1,
                              width: 105,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(
                                255, 236, 246, 251), // لون الخلفية
                            foregroundColor: Color(0xFF013E5D), // لون النص
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10), // تعديل المسافات الداخلية
                          ),
                          child: const Text("+ Add Link"),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Image.asset('assets/Clip path group.png', width: 24, height: 24),
                            onPressed: () {}),
                        IconButton(
                            icon: Image.asset('assets/twitter.png', width: 24, height: 24),
                            onPressed: () {}),
                        IconButton(
                            icon: Image.asset('assets/world.png', width: 24, height: 24),
                            onPressed: () {}),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
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
                    const Text("Experiences",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Container(
                      height: 1,
                      width: 105,
                      color: Colors.orange,
                    ),
                    Column(
                      children: const [
                        ListTile(
  leading: CircleAvatar(
    radius: 5, // حجم الأيقونة
    backgroundImage: AssetImage('assets/Ellipse.png'), // الصورة
  ),
  title: Text("Senior Fullstack Developer - Xceed"),
                          subtitle: Text("May, 2023 - Currently"),
                        ),
                        ListTile(
  leading: CircleAvatar(
    radius: 5, // حجم الأيقونة
    backgroundImage: AssetImage('assets/Ellipse.png'), // الصورة
  ),
  title: Text("Senior Fullstack Developer - Oracle"),
                          subtitle: Text("March 2021 - May 2023"),
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
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
                    const Text("Education",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Container(
                      height: 1,
                      width: 90,
                      color: Colors.orange,
                    ),
                    Column(
                      children: const [
                        
                        ListTile(
  leading: CircleAvatar(
    radius: 5, // حجم الأيقونة
    backgroundImage: AssetImage('assets/Ellipse.png'), // الصورة
  ),
  title: Text("Computer Science "),
                          subtitle: Text(" Cairo University - Egypt"),
                        ),
                        ListTile(
  leading: CircleAvatar(
    radius: 5, // حجم الأيقونة
    backgroundImage: AssetImage('assets/Ellipse.png'), // الصورة
  ),
  title: Text("Computer Science "),
                          subtitle: Text(" Cairo University - Egypt"),
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
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
                    const Text("Skills",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Container(
                      height: 1,
                      width: 55,
                      color: Colors.orange,
                    ),
                    Column(
                      children: const [
                        ListTile(
leading: CircleAvatar(
    radius: 5, // حجم الأيقونة
    backgroundImage: AssetImage('assets/Ellipse.png'), // الصورة
  ),                          title: Text("Senior Fullstack Developer - Xceed"),
                          subtitle: Text("May, 2023 - Currently"),
                        ),
                        ListTile(
leading: CircleAvatar(
    radius: 5, // حجم الأيقونة
    backgroundImage: AssetImage('assets/Ellipse.png'), // الصورة
  ),                          title: Text("Senior Fullstack Developer - Oracle"),
                          subtitle: Text("March 2021 - May 2023"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
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
