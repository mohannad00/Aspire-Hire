import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class PdfViewerScreen extends StatelessWidget {
  final String filePath;
  final String fileName;

  const PdfViewerScreen({
    Key? key,
    required this.filePath,
    required this.fileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('DEBUG: PdfViewerScreen initialized');
    print('DEBUG: File path: $filePath');
    print('DEBUG: File name: $fileName');
    
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
                    Expanded(
                      child: Center(
                        child: Text(
                          fileName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add share functionality here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Share functionality coming soon!'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      icon: const Icon(Icons.share, color: Colors.white),
                      tooltip: 'Share PDF',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<bool>(
        future: _checkFileExists(),
        builder: (context, snapshot) {
          print('DEBUG: FutureBuilder state: ${snapshot.connectionState}');
          print('DEBUG: FutureBuilder has data: ${snapshot.hasData}');
          print('DEBUG: FutureBuilder has error: ${snapshot.hasError}');
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('DEBUG: Showing loading indicator');
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF044463)),
            );
          }

          if (snapshot.hasError || !snapshot.data!) {
            print('DEBUG: File not found or error occurred');
            print('DEBUG: Error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'PDF file not found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF013E5D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'File path: $filePath',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF044463),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          print('DEBUG: Loading PDF viewer with file: $filePath');
          return SfPdfViewer.file(
            File(filePath),
            canShowPaginationDialog: true,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            enableDoubleTapZooming: true,
            enableTextSelection: true,
            pageLayoutMode: PdfPageLayoutMode.single,
            interactionMode: PdfInteractionMode.pan,
            enableDocumentLinkAnnotation: true,
            enableHyperlinkNavigation: true,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              print('DEBUG: PDF loaded successfully');
              print('DEBUG: Number of pages: ${details.document.pages.count}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'PDF loaded successfully! Pages: ${details.document.pages.count}',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              print('DEBUG: PDF load failed');
              print('DEBUG: Error: ${details.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load PDF: ${details.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _checkFileExists() async {
    try {
      print('DEBUG: Checking if file exists: $filePath');
      final file = File(filePath);
      final exists = await file.exists();
      print('DEBUG: File exists: $exists');
      
      if (exists) {
        final fileSize = await file.length();
        print('DEBUG: File size: $fileSize bytes');
      }
      
      return exists;
    } catch (e) {
      print('DEBUG: Error checking file existence: $e');
      return false;
    }
  }
}
