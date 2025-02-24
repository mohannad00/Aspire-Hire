// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously

import 'package:aspirehire/core/components/ReusableComponent.dart';
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
  File? selectedCV; // الملف المختار
  String? cvFileName; // اسم ملف السيرة الذاتية

  // دالة اختيار ملف PDF فقط
  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // السماح فقط بملفات PDF
    );

    if (result != null) {
      setState(() {
        selectedCV = File(result.files.single.path!);
        cvFileName = result.files.single.name;
      });
    }
  }

  // دالة رفع السيرة الذاتية
  Future<void> uploadCV() async {
    if (selectedCV == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a CV first!")),
      );
      return;
    }

    try {
      Dio dio = Dio();
      String uploadUrl = ""; // رابط API الرفع

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات الوظيفة
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/dell.png'), // صورة الشركة
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Frontend Developer",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Dell • Cairo • Fulltime", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // رفع السيرة الذاتية
            const Text("Upload CV", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Add your CV/Resume to apply for a job", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickPDF,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cvFileName ?? "Upload CV/Resume", style: const TextStyle(color: Colors.grey)),
                    const Icon(Icons.upload_file, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // خطاب التغطية
            const Text("Cover letter", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Explain why you are the right person for this job",hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "*If you don’t upload a CV, your default resume from your profile will be used automatically",
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
            const SizedBox(height: 20),

            // زر التقديم
            Center(
              child: SizedBox(
                width: 327,
                height: 48,
                child: ReusableComponents.reusableButton(
                  title: 'Apply Now',
                  fontSize: 15,
                  backgroundColor: const Color(0xFF013E5D),
                  textColor: Colors.white,
                  onPressed: uploadCV, // عند الضغط يتم رفع السيرة الذاتية
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
