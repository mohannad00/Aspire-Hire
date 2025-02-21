// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:aspirehire/core/components/ReusableComponent.dart';
import 'package:aspirehire/features/choosing_role/ChoosingRole.dart';
import 'package:aspirehire/features/job_post/CreatePost.dart';
import 'package:flutter/material.dart';
import 'package:aspirehire/features/job_search/JobSearch.dart';
import 'package:aspirehire/features/profile/ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          Container(
                  height: 85,
                  decoration: const BoxDecoration(
                    color: Color(0xFF013E5D),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Row(
                      children: [
                        SizedBox(width: 10,),
                      const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(''),
                  ),
                  SizedBox(width: 10,),
                      Text("Hello,Mustafa",style: TextStyle(color: Colors.white),),
                     ],),
                     
                      IconButton(
  icon:  Image.asset('assets/mage_notification-bell.png', width: 24, height: 24),
  onPressed: () {},
)
],
                  ),
                ),
                
          SizedBox(height: 10),
          Center(
  child: Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePost()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          "Write a post!",
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      ),
    ),
  ),
),


          SizedBox(height: 10),
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
         backgroundColor: Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Color.fromARGB(255, 0, 0, 0), // لون النص
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // تعديل المسافات
      ),
      child: Row(
        children: [
          Image.asset('assets/proicons_photo.png', width: 18, height: 18), // أيقونة الصورة
          SizedBox(width: 5), // مسافة بين الأيقونة والنص
          Text("Photo"),
        ],
      ),
    ),
    ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Color.fromARGB(255, 0, 0, 0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Row(
        children: [
          Image.asset('assets/proicons_video.png', width: 18, height: 18), // أيقونة الصورة
          SizedBox(width: 5),
          Text("Video"),
        ],
      ),
    ),
    ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Color.fromARGB(255, 0, 0, 0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Row(
        children: [
          Image.asset('assets/ph_article.png', width: 18, height: 18), // أيقونة الصورة
          SizedBox(width: 5),
          Text("Document"),
        ],
      ),
    ),
  ],
),SizedBox(height: 20),
 Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.orange,
                            ),

          SizedBox(height: 20),
          Text('Recommended Jobs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          JobCard(),
          JobCard(),
          SizedBox(height: 20),
          PostCard(),
          PostCard(),
        ],
      ),
    ),
    Center(child: Text("Search Page", style: TextStyle(fontSize: 24))),
    Center(child: Text("List Page", style: TextStyle(fontSize: 24))),
    Center(child: Text("Profile Page", style: TextStyle(fontSize: 24))),
  ];

  final List<String> _labels = ["Home", "Search", "List", "Profile"];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JobSearch()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF013E5D),
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
      onTap: () {
        _onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFF013E5D) : Colors.white,
              size: 28,
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: TextStyle(
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

class JobCard extends StatelessWidget {
  const JobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
              Image.asset('assets/logo.png', width: 50, height: 50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Web Designer.',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'hp  •  Part-time\nEgypt, Cairo',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Handle close button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage('')),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mustafa Mahmoud', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('2,871 followers  •  1d'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
              style: TextStyle(
                fontFamily:'Poppins' ,
                fontSize: 15),),
            TextButton(
  onPressed: () {  },
  child: Text('56 comments'),
),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {}, icon: Image.asset('assets/like-wrapper.png', width: 24, height: 24),),
                        Text('258'),
                        SizedBox(width: 50),
                    IconButton(
                        onPressed: () {}, icon:Image.asset('assets/comment-wrapper.png', width: 24, height: 24),),
                   SizedBox(width: 50),
                    IconButton(
                        onPressed: () {}, icon: Image.asset('assets/send-wrapper.png', width: 24, height: 24),),
                    SizedBox(width: 50),
                  ],
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}