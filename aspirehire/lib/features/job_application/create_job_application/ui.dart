import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../../config/datasources/cache/shared_pref.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../features/hame_nav_bar/home_nav_bar.dart';
import 'state_management/create_job_application_cubit.dart';

class CreateJobApplicationScreen extends StatefulWidget {
  final String jobPostId;
  final String jobTitle;
  final String companyName;
  final String location;
  final String jobType;

  const CreateJobApplicationScreen({
    Key? key,
    required this.jobPostId,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.jobType,
  }) : super(key: key);

  @override
  State<CreateJobApplicationScreen> createState() =>
      _CreateJobApplicationScreenState();
}

class _CreateJobApplicationScreenState
    extends State<CreateJobApplicationScreen> {
  File? selectedResume;
  String? resumeFileName;
  final TextEditingController _coverLetterController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickResume() async {
    try {
      print('🔵 [CreateJobApplicationScreen] Starting file picker...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('🔵 [CreateJobApplicationScreen] File selected: ${file.name}');
        print('🔵 [CreateJobApplicationScreen] File path: ${file.path}');
        print('🔵 [CreateJobApplicationScreen] File size: ${file.size} bytes');
        print(
          '🔵 [CreateJobApplicationScreen] File extension: ${file.extension}',
        );

        // Validate file extension
        if (file.extension?.toLowerCase() != 'pdf') {
          print(
            '❌ [CreateJobApplicationScreen] Invalid file type: ${file.extension}',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a PDF file only'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Validate file size (max 10MB)
        if (file.size > 10 * 1024 * 1024) {
          print(
            '❌ [CreateJobApplicationScreen] File too large: ${file.size} bytes',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'File is too large. Please select a file smaller than 10MB',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          selectedResume = File(file.path!);
          resumeFileName = file.name;
        });

        print('✅ [CreateJobApplicationScreen] File selected successfully');
      } else {
        print('🔵 [CreateJobApplicationScreen] No file selected');
      }
    } catch (e) {
      print('❌ [CreateJobApplicationScreen] Error picking file: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedResume == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a resume file'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      print('🔵 [CreateJobApplicationScreen] Retrieving token from cache...');
      final token = await CacheHelper.getData('token');
      print('🔵 [CreateJobApplicationScreen] Raw token from cache: $token');
      print('🔵 [CreateJobApplicationScreen] Token type: ${token.runtimeType}');
      print(
        '🔵 [CreateJobApplicationScreen] Token length: ${token?.toString().length}',
      );

      if (token == null) {
        print('❌ [CreateJobApplicationScreen] Token is null from cache');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication required. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (token.toString().trim().isEmpty) {
        print('❌ [CreateJobApplicationScreen] Token is empty string');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication token is empty. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Use token directly without adding Bearer prefix (following app pattern)
      String finalToken = token.toString();
      print(
        '🔵 [CreateJobApplicationScreen] Final token to use: ${finalToken.substring(0, finalToken.length > 20 ? 20 : finalToken.length)}...',
      );
      print(
        '🔵 [CreateJobApplicationScreen] Calling cubit with jobPostId: ${widget.jobPostId}',
      );
      print(
        '🔵 [CreateJobApplicationScreen] Cover letter length: ${_coverLetterController.text.trim().length}',
      );
      print(
        '🔵 [CreateJobApplicationScreen] Resume file path: ${selectedResume!.path}',
      );

      context.read<CreateJobApplicationCubit>().createJobApplication(
        jobPostId: widget.jobPostId,
        coverLetter: _coverLetterController.text.trim(),
        attachment: selectedResume!,
        token: finalToken,
      );
    } catch (e) {
      print(
        '❌ [CreateJobApplicationScreen] Exception in _submitApplication: $e',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _coverLetterController.dispose();
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
                color: const Color(0xFF044463), // Dark blue
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 90),
                          const Center(
                            child: Text(
                              'Apply for Job',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<CreateJobApplicationCubit, CreateJobApplicationState>(
        listener: (context, state) {
          if (state is CreateJobApplicationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Application submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to home nav bar and clear all previous routes
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeNavBar()),
              (route) => false,
            );
          } else if (state is CreateJobApplicationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child:
            BlocBuilder<CreateJobApplicationCubit, CreateJobApplicationState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Information Header
                        _buildJobInfoHeader(),
                        const SizedBox(height: 24),

                        // Resume Upload Section
                        _buildResumeUploadSection(),
                        const SizedBox(height: 24),

                        // Cover Letter Section
                        _buildCoverLetterSection(),
                        const SizedBox(height: 16),

                        // Info Text
                        _buildInfoText(),
                        const SizedBox(height: 32),

                        // Submit Button
                        _buildSubmitButton(state),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _buildJobInfoHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(Icons.work, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            widget.jobTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.companyName,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                widget.location,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Icon(Icons.schedule, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                widget.jobType,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumeUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Resume/CV",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Upload your resume in PDF format",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickResume,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedResume != null ? AppColors.primary : Colors.grey,
                width: selectedResume != null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color:
                  selectedResume != null
                      ? AppColors.primary.withOpacity(0.05)
                      : null,
            ),
            child: Row(
              children: [
                Icon(
                  selectedResume != null
                      ? Icons.check_circle
                      : Icons.upload_file,
                  color:
                      selectedResume != null ? AppColors.primary : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedResume != null
                            ? 'Resume Selected'
                            : 'Choose PDF file',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color:
                              selectedResume != null
                                  ? AppColors.primary
                                  : Colors.grey,
                        ),
                      ),
                      if (resumeFileName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          resumeFileName!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverLetterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cover Letter",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Explain why you are the right person for this job",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _coverLetterController,
          maxLines: 6,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Cover letter is required';
            }
            if (value.trim().length < 50) {
              return 'Cover letter must be at least 50 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Write your cover letter here...",
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "If you don't upload a resume, your default resume from your profile will be used automatically",
              style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(CreateJobApplicationState state) {
    final isLoading = state is CreateJobApplicationLoading;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitApplication,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Text(
                  'Submit Application',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
      ),
    );
  }
}
