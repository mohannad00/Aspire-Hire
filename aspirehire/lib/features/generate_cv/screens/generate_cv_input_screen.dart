import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../core/models/CvRequest.dart';
import '../state_management/generate_cv_cubit.dart';
import '../state_management/generate_cv_state.dart';
import 'generate_cv_result_screen.dart';

class GenerateCvInputScreen extends StatefulWidget {
  const GenerateCvInputScreen({Key? key}) : super(key: key);

  @override
  State<GenerateCvInputScreen> createState() => _GenerateCvInputScreenState();
}

class _GenerateCvInputScreenState extends State<GenerateCvInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skillController = TextEditingController();
  final List<String> _skills = [];
  Color _themeColor = const Color(0xFFAE06C1);
  String _selectedThemeColor = '#AE06C1';

  // Controllers for form fields
  final Map<String, TextEditingController> _controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'nationality': TextEditingController(),
    'phone': TextEditingController(),
    'dob': TextEditingController(),
    'gender': TextEditingController(),
    'education': TextEditingController(),
    'experience': TextEditingController(),
    'language': TextEditingController(),
    'jobTitle': TextEditingController(),
    'company': TextEditingController(),
    'hireDate': TextEditingController(),
    'github': TextEditingController(),
    'email': TextEditingController(),
    'linkedin': TextEditingController(),
    'summary': TextEditingController(),
  };

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        _skills.add(_skillController.text);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
  }

  void _generateCv() {
    if (_formKey.currentState!.validate()) {
      final cvData = CvData(
        firstName: _controllers['firstName']!.text,
        lastName: _controllers['lastName']!.text,
        nationality: _controllers['nationality']!.text,
        phone: _controllers['phone']!.text,
        dob: _controllers['dob']!.text,
        gender: _controllers['gender']!.text,
        education: _controllers['education']!.text,
        skills: _skills,
        experience: _controllers['experience']!.text,
        language: _controllers['language']!.text,
        jobTitle: _controllers['jobTitle']!.text,
        company: _controllers['company']!.text,
        hireDate: _controllers['hireDate']!.text,
        github: _controllers['github']!.text,
        email: _controllers['email']!.text,
        linkedin: _controllers['linkedin']!.text,
      );

      final request = CvRequest(
        cvData: cvData,
        summary: _controllers['summary']!.text,
        themeColor: _selectedThemeColor,
      );

      context.read<GenerateCvCubit>().generateCv(request);
    }
  }

  void _pickColor() async {
    Color pickedColor = _themeColor;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a theme color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickedColor,
              onColorChanged: (color) {
                pickedColor = color;
              },
              enableAlpha: false,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                setState(() {
                  _themeColor = pickedColor;
                  _selectedThemeColor =
                      '#${pickedColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String fieldName, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[fieldName],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF013E5D),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF044463),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Generate CV',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<GenerateCvCubit, GenerateCvState>(
        listener: (context, state) {
          if (state is GenerateCvSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        GenerateCvResultScreen(cvResponse: state.cvResponse),
              ),
            );
          } else if (state is GenerateCvFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Professional CV Generator',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF013E5D),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fill in your details to generate a professional CV',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Personal Information Section
                _buildSectionTitle('Personal Information'),
                _buildTextField('firstName', 'First Name', Icons.person),
                _buildTextField('lastName', 'Last Name', Icons.person),
                _buildTextField('nationality', 'Nationality', Icons.flag),
                _buildTextField('phone', 'Phone', Icons.phone),
                _buildTextField(
                  'dob',
                  'Date of Birth (YYYY-MM-DD)',
                  Icons.calendar_today,
                ),
                _buildTextField('gender', 'Gender', Icons.person_outline),
                _buildTextField('email', 'Email', Icons.email),

                const SizedBox(height: 20),

                // Education & Experience Section
                _buildSectionTitle('Education & Experience'),
                _buildTextField('education', 'Education', Icons.school),
                _buildTextField('experience', 'Experience Level', Icons.work),
                _buildTextField('language', 'Languages', Icons.language),

                const SizedBox(height: 20),

                // Skills Section
                _buildSectionTitle('Skills'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _skillController,
                        decoration: InputDecoration(
                          hintText: 'Add a skill',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        onFieldSubmitted: (_) => _addSkill(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addSkill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF013E5D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_skills.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _skills.asMap().entries.map((entry) {
                          final index = entry.key;
                          final skill = entry.value;
                          return Chip(
                            label: Text(skill),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () => _removeSkill(index),
                            backgroundColor: const Color(
                              0xFF013E5D,
                            ).withOpacity(0.1),
                          );
                        }).toList(),
                  ),

                const SizedBox(height: 20),

                // Current Position Section
                _buildSectionTitle('Current Position'),
                _buildTextField('jobTitle', 'Job Title', Icons.work),
                _buildTextField('company', 'Company', Icons.business),
                _buildTextField(
                  'hireDate',
                  'Hire Date (YYYY-MM-DD)',
                  Icons.date_range,
                ),

                const SizedBox(height: 20),

                // Social Links Section
                _buildSectionTitle('Social Links'),
                _buildTextField('github', 'GitHub URL', Icons.code),
                _buildTextField('linkedin', 'LinkedIn URL', Icons.link),

                const SizedBox(height: 20),

                // Summary Section
                _buildSectionTitle('Professional Summary'),
                TextFormField(
                  controller: _controllers['summary'],
                  decoration: InputDecoration(
                    labelText: 'Professional Summary',
                    hintText: 'Enter your professional summary...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Professional Summary is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Theme Color Section
                _buildSectionTitle('CV Theme Color'),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickColor,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: _themeColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Center(
                            child: Text(
                              'Tap to pick color',
                              style: TextStyle(
                                color:
                                    useWhiteForeground(_themeColor)
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _themeColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Generate Button
                BlocBuilder<GenerateCvCubit, GenerateCvState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state is GenerateCvLoading ? null : _generateCv,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF013E5D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          state is GenerateCvLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text(
                                'Generate CV',
                                style: TextStyle(fontSize: 16),
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
