// ignore_for_file: file_names, use_super_parameters

import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
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
            const SizedBox(height: 10),
            const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.', style: TextStyle(fontSize: 15)),
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
