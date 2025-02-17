import 'package:aspirehire/features/home_screen/HomeScreen.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';
import 'package:flutter/material.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ReusableComponents.reusableBackButton(
          context: context,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text("Create Post"),
        actions: [
          TextButton(
            onPressed: () {
              // إضافة منطق النشر هنا
            },
            child: SizedBox(
              width: 100,
              child: ReusableComponents.reusableButton(
                title: 'Post',
                fontSize: 15,
                backgroundColor: const Color(0xFF013E5D),
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة البروفايل + الاسم
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(''), // ضع صورة البروفايل هنا
                ),
                const SizedBox(width: 10),
                const Text(
                  "Mustafa Mahmoud",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // صندوق الكتابة
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write a post!",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // خيارات: صورة - فيديو - مستند
            Column(
              children: [
                _buildOption(Icons.photo, "Photo"),
                _buildOption(Icons.video_collection, "Video"),
                _buildOption(Icons.insert_drive_file, "Document"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(label),
      onTap: () {
        // إضافة وظيفة الاختيار هنا
      },
    );
  }
}
