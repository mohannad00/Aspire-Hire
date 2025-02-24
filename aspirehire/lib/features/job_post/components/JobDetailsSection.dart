// ignore_for_file: file_names

import 'package:flutter/material.dart';

class JobDetailsSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String jobType;
  final String jobCategory;
  final Function(String) onJobTypeChanged;
  final Function(String) onJobCategoryChanged;

  const JobDetailsSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.jobType,
    required this.jobCategory,
    required this.onJobTypeChanged,
    required this.onJobCategoryChanged, required TextEditingController minSalaryController, required TextEditingController maxSalaryController, required TextEditingController addressController, required TextEditingController skillsController, required String salaryType, required String experienceLevel, required String country, required String city, required List<String> selectedSkills, required void Function(dynamic val) onSalaryTypeChanged, required void Function(dynamic val) onExperienceLevelChanged, required void Function(dynamic val) onCountryChanged, required void Function(dynamic val) onCityChanged, required Null Function(dynamic val) onSkillAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Job Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        _buildSectionTitle('Basic Information'),
        _buildTextField('Job Title*', titleController),
        _buildTextField(
          'Job Description*',
          descriptionController,
          maxLines: 3,
        ),
        _buildDropdown(
          'Job Type*',
          ['Full Time', 'Part Time'],
          jobType,
          onJobTypeChanged,
        ),
        _buildDropdown(
          'Job Category*',
          ['Designer', 'Developer', 'Engineer'],
          jobCategory,
          onJobCategoryChanged,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF013E5D),
          fontFamily: "Poppins",
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
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
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: const TextStyle(fontFamily: "Poppins")),
                  ),
                )
                .toList(),
            onChanged: (val) => onChanged(val!),
          ),
        ),
      ),
    );
  }
}
