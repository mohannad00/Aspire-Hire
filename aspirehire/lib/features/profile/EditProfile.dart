// edit_profile.dart
import 'package:aspirehire/features/profile/components/CustomAppBar.dart';
import 'package:aspirehire/features/profile/components/ProfileAvatar.dart';
import 'package:aspirehire/features/profile/components/SectionComponent.dart';
import 'package:aspirehire/features/profile/components/TextField%20Component.dart';
import 'package:aspirehire/features/profile/components/UploadButtonComponent.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ProfileAvatar()),
            SizedBox(height: 20),
            CustomTextField(label: 'First name*', hint: 'First name'),
            CustomTextField(label: 'Last name*', hint: 'Last name'),
            CustomTextField(label: 'Position*', hint: 'Position'),
            CustomTextField(label: 'Phone number*', hint: 'Phone number'),
            CustomTextField(label: 'Location*', hint: 'Location'),
            SizedBox(height: 20),
            UploadButton(),
            SizedBox(height: 20),
            CustomSection(title: 'On the web', items: [
              'https://github.com/mostafa/proj',
              'https://twitter.com/mostafa-mondy',
              'https://www.website-name.com'
            ]),
            CustomSection(title: 'Experiences', items: [
              'Senior Fullstack Developer - Xceed',
              'Senior Fullstack Developer - Oracle',
              'Frontend Developer - Xceed'
            ]),
            CustomSection(title: 'Education', items: [
              'Computer Science - Cairo University',
              'High School Diploma - Alorman Secor'
            ]),
          ],
        ),
      ),
    );
  }
}
