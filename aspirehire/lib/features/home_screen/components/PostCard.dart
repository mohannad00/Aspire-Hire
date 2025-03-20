// ignore_for_file: file_names, use_super_parameters

import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String jobType;
  final String location;
  final String description;

  const PostCard({
    Key? key,
    required this.jobTitle,
    required this.company,
    required this.jobType,
    required this.location,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3, // Adds shadow to the card
      shadowColor: Colors.grey.withOpacity(0.5), // Customize shadow color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage('assets/avatar.png')),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Web Designer', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('hp  •  Part-time  •  Egypt, Cairo'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {}, icon: Image.asset('assets/like-wrapper.png', width: 24, height: 24)),
                const SizedBox(width: 50),
                IconButton(onPressed: () {}, icon: Image.asset('assets/comment-wrapper.png', width: 24, height: 24)),
                const SizedBox(width: 50),
                IconButton(onPressed: () {}, icon: Image.asset('assets/send-wrapper.png', width: 24, height: 24)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}