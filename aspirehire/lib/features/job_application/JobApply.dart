import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class ApplyJob extends StatefulWidget {
  const ApplyJob({super.key});

  @override
  _ApplyJobState createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  File? selectedCV;
  String? cvFileName;

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

  Future<void> uploadCV() async {
    if (selectedCV == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a CV first!")),
      );
      return;
    }

    try {
      Dio dio = Dio();
      String uploadUrl = "";

      FormData formData = FormData.fromMap({
        "cv": await MultipartFile.fromFile(selectedCV!.path, filename: "cv.pdf"),
      });

      Response response = await dio.post(uploadUrl, data: formData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("CV uploaded successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload CV")),
        );
      }
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error uploading CV")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Apply Job", style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
        ),
        backgroundColor: const Color(0xFF013E5D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                      backgroundImage: AssetImage('assets/Google.png'),
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
              const UploadCVSection(),
              const SizedBox(height: 20),
              const CoverLetterSection(),
              const SizedBox(height: 10),
              const Text(
                "*If you don’t upload a CV, your default resume from your profile will be used automatically",
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Center(
                child: ApplyButton(
                  onPressed: uploadCV,
                ),
              ),
            ],
          ),
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
    return Text(
      name,
      style: const TextStyle(color: Colors.grey),
    );
  }
}

class JobLocation extends StatelessWidget {
  final String location;

  const JobLocation({required this.location, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      location,
      style: const TextStyle(color: Colors.grey),
    );
  }
}

class JobType extends StatelessWidget {
  final String type;

  const JobType({required this.type, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      type,
      style: const TextStyle(color: Colors.grey),
    );
  }
}

class UploadCVSection extends StatelessWidget {
  const UploadCVSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload CV", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Add your CV/Resume to apply for a job", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Add logic to pick a file
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
                const Text("Upload CV/Resume", style: TextStyle(color: Colors.grey)),
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
  const CoverLetterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Cover letter", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const TextField(
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
        child: const Text(
          'Apply Now',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}