// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aspirehire/features/home_screen/HomeScreenJobSeeker.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';
import 'package:aspirehire/features/job_post/components/PostOptions%20.dart';
import 'package:aspirehire/features/job_post/components/PostTextField%20.dart';
import 'package:aspirehire/features/job_post/components/ProfileHeader%20.dart';
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
              MaterialPageRoute(builder: (context) => const HomeScreenJobSeeker()),
            );
          },
        ),
        title: const Text("Create Post"),
        actions: [
          TextButton(
            onPressed: () {},
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
            const ProfileHeader(),
            const SizedBox(height: 10),
            const PostTextField(),
            const SizedBox(height: 20),
            const PostOptions(),
          ],
        ),
      ),
    );
  }
}
