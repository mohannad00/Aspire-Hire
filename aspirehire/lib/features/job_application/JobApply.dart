import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'create_job_application/state_management/create_job_application_cubit.dart';
import '../../config/datasources/cache/shared_pref.dart';

class ApplyJob extends StatefulWidget {
  final String jobPostId;

  const ApplyJob({super.key, required this.jobPostId});

  @override
  _ApplyJobState createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  File? selectedCV;
  String? cvFileName;
  final TextEditingController _coverLetterController = TextEditingController();

  void _showAlreadyAppliedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.orange, size: 28),
              const SizedBox(width: 8),
              Text(
                'Already Applied',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'You have already applied for this job position.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              Text(
                'Success!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Your job application has been submitted successfully!',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedCV = File(result.files.single.path!);
        cvFileName = result.files.single.name;
      });
    }
  }

  Future<void> submitApplication() async {
    if (_coverLetterController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write a cover letter!")),
      );
      return;
    }

    if (selectedCV == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a CV first!")),
      );
      return;
    }

    try {
      final token = await CacheHelper.getData('token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token not found')),
        );
        return;
      }

      context.read<CreateJobApplicationCubit>().createJobApplication(
        jobPostId: widget.jobPostId,
        coverLetter: _coverLetterController.text.trim(),
        attachment: selectedCV!,
        token: token,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateJobApplicationCubit(),
      child: BlocListener<CreateJobApplicationCubit, CreateJobApplicationState>(
        listener: (context, state) {
          if (state is CreateJobApplicationSuccess) {
            _showSuccessDialog();
          } else if (state is CreateJobApplicationFailure) {
            // Check if the error message indicates already applied
            if (state.message.contains('You can apply for this job once') ||
                state.message.contains('already applied')) {
              _showAlreadyAppliedDialog();
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          }
        },
        child: BlocBuilder<
          CreateJobApplicationCubit,
          CreateJobApplicationState
        >(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Center(
                  child: Text(
                    "Apply Job",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                backgroundColor: const Color(0xFF013E5D),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body:
                  state is CreateJobApplicationLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage(
                                        'assets/Google.png',
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    JobTitle(title: "Frontend Developer"),
                                    SizedBox(height: 5),
                                    CompanyName(name: "Dell"),
                                    SizedBox(height: 5),
                                    JobLocation(location: "Cairo"),
                                    SizedBox(height: 5),
                                    JobType(type: "Full-time"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              UploadCVSection(
                                selectedCV: selectedCV,
                                cvFileName: cvFileName,
                                onPickPDF: pickPDF,
                              ),
                              const SizedBox(height: 20),
                              CoverLetterSection(
                                controller: _coverLetterController,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "*If you don't upload a CV, your default resume from your profile will be used automatically",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ApplyButton(
                                  onPressed: submitApplication,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }
}

// Reusable Components

class JobTitle extends StatelessWidget {
  final String title;

  const JobTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class CompanyName extends StatelessWidget {
  final String name;

  const CompanyName({required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(name, style: const TextStyle(color: Colors.grey));
  }
}

class JobLocation extends StatelessWidget {
  final String location;

  const JobLocation({required this.location, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(location, style: const TextStyle(color: Colors.grey));
  }
}

class JobType extends StatelessWidget {
  final String type;

  const JobType({required this.type, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(type, style: const TextStyle(color: Colors.grey));
  }
}

class UploadCVSection extends StatelessWidget {
  final File? selectedCV;
  final String? cvFileName;
  final VoidCallback onPickPDF;

  const UploadCVSection({
    Key? key,
    required this.selectedCV,
    required this.cvFileName,
    required this.onPickPDF,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload CV", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          "Add your CV/Resume to apply for a job",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            onPickPDF();
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCV == null ? "Upload CV/Resume" : cvFileName!,
                  style: const TextStyle(color: Colors.grey),
                ),
                const Icon(Icons.upload_file, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CoverLetterSection extends StatelessWidget {
  final TextEditingController controller;

  const CoverLetterSection({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cover letter",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Explain why you are the right person for this job",
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class ApplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ApplyButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 327,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF013E5D),
          foregroundColor: Colors.white,
        ),
        child: const Text('Apply Now', style: TextStyle(fontSize: 15)),
      ),
    );
  }
}
