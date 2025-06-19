import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../state_management/ats_evaluate_cubit.dart';
import '../state_management/ats_evaluate_state.dart';
import 'ats_result_screen.dart';

class ATSInputScreen extends StatefulWidget {
  const ATSInputScreen({Key? key}) : super(key: key);

  @override
  State<ATSInputScreen> createState() => _ATSInputScreenState();
}

class _ATSInputScreenState extends State<ATSInputScreen> {
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedResumePath;
  String? _selectedFileName;

  @override
  void dispose() {
    _jobDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickResumeFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _selectedResumePath = result.files.single.path;
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _evaluateResume() {
    if (_formKey.currentState!.validate() && _selectedResumePath != null) {
      context.read<ATSEvaluateCubit>().evaluateResume(
        resumeFilePath: _selectedResumePath!,
        jobDescription: _jobDescriptionController.text,
      );
    } else if (_selectedResumePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a resume PDF file'),
          backgroundColor: Colors.red,
        ),
      );
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
                  color: const Color(0xFF044463), // Dark blue
                  child: const Row(
                    children: [
                       Expanded(
                        child: Center(
                          child: Text(
                            'ATS Resume Check',
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
      body: BlocListener<ATSEvaluateCubit, ATSEvaluateState>(
        listener: (context, state) {
          if (state is ATSEvaluateSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ATSResultScreen(evaluation: state.evaluation),
              ),
            );
          } else if (state is ATSEvaluateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Resume Evaluation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF013E5D),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload your resume PDF and job description to get ATS optimization suggestions.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Resume File Upload
                const Text(
                  'Resume PDF',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),
                  child: Column(
                    children: [
                      if (_selectedFileName == null)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No file selected',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Upload your resume in PDF format',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red[600],
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedFileName!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'PDF file selected',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedResumePath = null;
                                    _selectedFileName = null;
                                  });
                                },
                                icon: const Icon(Icons.close),
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF013E5D),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: _pickResumeFile,
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.white,
                          ),
                          label: Text(
                            _selectedFileName == null
                                ? 'Select PDF File'
                                : 'Change File',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Job Description Input
                const Text(
                  'Job Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _jobDescriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Paste the job description here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the job description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Evaluate Button
                BlocBuilder<ATSEvaluateCubit, ATSEvaluateState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state is ATSEvaluateLoading ? null : _evaluateResume,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF013E5D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          state is ATSEvaluateLoading
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
                                'Evaluate Resume',
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
}
