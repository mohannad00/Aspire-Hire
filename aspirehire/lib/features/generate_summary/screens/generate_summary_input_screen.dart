import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/SummaryRequest.dart';
import '../state_management/generate_summary_cubit.dart';
import '../state_management/generate_summary_state.dart';
import 'generate_summary_result_screen.dart';

class GenerateSummaryInputScreen extends StatefulWidget {
  const GenerateSummaryInputScreen({Key? key}) : super(key: key);

  @override
  State<GenerateSummaryInputScreen> createState() =>
      _GenerateSummaryInputScreenState();
}

class _GenerateSummaryInputScreenState
    extends State<GenerateSummaryInputScreen> {
  final _formKey = GlobalKey<FormState>();
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
    'tone': TextEditingController(),
  };

  final List<String> _skills = [];
  final TextEditingController _skillController = TextEditingController();

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    if (_skillController.text.trim().isNotEmpty) {
      setState(() {
        _skills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
  }

  void _generateSummary() {
    if (_formKey.currentState!.validate()) {
      final request = SummaryRequest(
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
        tone: _controllers['tone']!.text,
      );

      context.read<GenerateSummaryCubit>().generateSummary(request);
    }
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
                child: const Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Generate Summary',
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
      body: BlocListener<GenerateSummaryCubit, GenerateSummaryState>(
        listener: (context, state) {
          if (state is GenerateSummarySuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        GenerateSummaryResultScreen(summary: state.summary),
              ),
            );
          } else if (state is GenerateSummaryFailure) {
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
                  'Professional Summary Generator',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF013E5D),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fill in your details to generate a professional summary',
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

                // Tone Section
                _buildSectionTitle('Summary Tone'),
                _buildTextField(
                  'tone',
                  'Tone (e.g., Formal, Casual, Professional)',
                  Icons.style,
                ),

                const SizedBox(height: 32),

                // Generate Button
                BlocBuilder<GenerateSummaryCubit, GenerateSummaryState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state is GenerateSummaryLoading
                              ? null
                              : _generateSummary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF013E5D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          state is GenerateSummaryLoading
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
                                'Generate Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF013E5D),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
