import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../core/models/CvResponse.dart';
import 'pdf_viewer_screen.dart';
import 'simple_pdf_viewer_screen.dart';

class GenerateCvResultScreen extends StatefulWidget {
  final CvResponse cvResponse;
  final bool autoPreview;

  const GenerateCvResultScreen({
    Key? key,
    required this.cvResponse,
    this.autoPreview = false,
  }) : super(key: key);

  @override
  State<GenerateCvResultScreen> createState() => _GenerateCvResultScreenState();
}

class _GenerateCvResultScreenState extends State<GenerateCvResultScreen> {
  bool _hasAutoPreviewed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autoPreview && !_hasAutoPreviewed) {
      _hasAutoPreviewed = true;
      // Delay to ensure the screen is built before opening the PDF viewer
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _viewPdf(context);
      });
    }
  }

  void _viewPdf(BuildContext context) async {
    try {
      print('DEBUG: Starting PDF view process...');
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${widget.cvResponse.fileName}');
      print('DEBUG: Temporary file path: ${tempFile.path}');
      print('DEBUG: File name: ${widget.cvResponse.fileName}');
      await tempFile.writeAsBytes(widget.cvResponse.pdfData);
      print('DEBUG: PDF written to temporary file');
      final fileExists = await tempFile.exists();
      print('DEBUG: Temporary file exists: $fileExists');
      if (fileExists) {
        final fileSize = await tempFile.length();
        print('DEBUG: Temporary file size: $fileSize bytes');
        print('DEBUG: Navigating to PDF viewer with temporary file');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PdfViewerScreen(
                  filePath: tempFile.path,
                  fileName: widget.cvResponse.fileName,
                ),
          ),
        );
      } else {
        throw Exception('Failed to create temporary file');
      }
    } catch (e) {
      print('DEBUG: Error in _viewPdf: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('PDF Viewer Error'),
            content: const Text(
              'The PDF viewer encountered an error. Would you like to view PDF information and download options?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SimplePdfViewerScreen(
                            filePath: 'Temporary file',
                            fileName: widget.cvResponse.fileName,
                            pdfData: widget.cvResponse.pdfData,
                          ),
                    ),
                  );
                },
                child: const Text('View Info'),
              ),
            ],
          );
        },
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
                          'Generated CV',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'CV Generated Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF013E5D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your CV has been generated successfully and is ready for preview.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          color: Color(0xFF013E5D),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Professional CV',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF013E5D),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _viewPdf(context),
                          icon: const Icon(Icons.visibility),
                          tooltip: 'Preview CV',
                          color: const Color(0xFF013E5D),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your CV has been generated and is ready for preview.',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Click the preview button below to view your professional CV.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewPdf(context),
                    icon: const Icon(Icons.visibility),
                    label: const Text('Preview CV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF013E5D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Generate New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
