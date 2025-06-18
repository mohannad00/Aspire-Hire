// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors

import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/features/home_screen/HomeCompany.dart';
import 'package:flutter/material.dart';

class PostJob extends StatefulWidget {
  const PostJob({super.key});

  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  String jobType = 'Full Time';
  String jobCategory = 'Designer';
  String salaryType = 'Monthly';
  String experienceLevel = 'Intermediate';
  String country = 'Egypt';
  String city = 'Cairo';

  List<String> selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF013E5D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeCompany()),
            );
          },
        ),
        title: const Text("Post a job", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Job Details",
                    style: TextStyle(fontFamily: "Poppins", fontSize: 24),
                  ),
                  Container(height: 1, width: 155, color: Colors.orange),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Basic Information",
              style: TextStyle(
                color: const Color(0xFF013E5D),
                fontFamily: "Poppins",
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),

            _buildTextField('Job Title*', _titleController),
            _buildTextField(
              'Job Description*',
              _descriptionController,
              maxLines: 3,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Job Type*',
                    ['Full Time', 'Part Time'],
                    jobType,
                    (val) => setState(() => jobType = val),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown(
                    'Job Category*',
                    ['Designer', 'Developer', 'Engineer'],
                    jobCategory,
                    (val) => setState(() => jobCategory = val),
                  ),
                ),
              ],
            ),
            _buildDropdown(
              'Salary',
              ['Monthly', 'Hourly'],
              salaryType,
              (val) => setState(() => salaryType = val),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Min Salary', _minSalaryController),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField('Max Salary', _maxSalaryController),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Skills & Experiences ",
              style: TextStyle(
                color: const Color(0xFF013E5D),
                fontFamily: "Poppins",
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
              'Skills',
              _skillsController,
              onSubmitted: (val) {
                setState(() {
                  selectedSkills.add(val);
                  _skillsController.clear();
                });
              },
            ),
            Wrap(
              children:
                  selectedSkills
                      .map((skill) => Chip(label: Text(skill)))
                      .toList(),
            ),
            _buildDropdown(
              'Experiences',
              ['Beginner', 'Intermediate', 'Expert'],
              experienceLevel,
              (val) => setState(() => experienceLevel = val),
            ),
            SizedBox(height: 20),
            Text(
              "Address & Location  ",
              style: TextStyle(
                color: const Color(0xFF013E5D),
                fontFamily: "Poppins",
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField('Address*', _addressController),
            _buildDropdown(
              'Country*',
              ['Egypt', 'USA'],
              country,
              (val) => setState(() => country = val),
            ),
            _buildDropdown(
              'City*',
              ['Cairo', 'New York'],
              city,
              (val) => setState(() => city = val),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 103,
                height: 48,
                child: ReusableButton.build(
                  title: 'Post',
                  fontSize: 15,
                  backgroundColor: const Color(0xFF013E5D),
                  textColor: Colors.white,
                  onPressed: () {
                    // TODO: Implement job posting logic here
                    // For now, just navigate back to home
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeCompany(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    Function(String)? onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items:
                items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            onChanged: (val) => onChanged(val!),
          ),
        ),
      ),
    );
  }
}
