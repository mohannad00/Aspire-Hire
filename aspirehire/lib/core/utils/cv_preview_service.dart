import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class CvPreviewService {
  static Future<void> previewCv({
    required BuildContext context,
    required String cvUrl,
    String? fileName,
  }) async {
    try {
      // Validate URL
      if (cvUrl.isEmpty) {
        throw Exception('CV URL is empty');
      }

      // Check if the URL is valid
      final uri = Uri.parse(cvUrl);
      if (!uri.hasScheme || !uri.hasAuthority) {
        throw Exception('Invalid CV URL format');
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF044463)),
                SizedBox(height: 16),
                Text(
                  'Loading CV...',
                  style: TextStyle(color: Color(0xFF044463), fontSize: 16),
                ),
              ],
            ),
          );
        },
      );

      // Download the PDF to temporary storage
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/${fileName ?? 'cv_${DateTime.now().millisecondsSinceEpoch}.pdf'}',
      );

      final dio = Dio();
      final response = await dio.get(
        cvUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          maxRedirects: 5,
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        await tempFile.writeAsBytes(response.data);

        // Close loading dialog
        Navigator.of(context).pop();

        // Navigate to PDF viewer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => CvPreviewScreen(
                  filePath: tempFile.path,
                  fileName: fileName ?? 'CV Preview',
                  cvUrl: cvUrl,
                ),
          ),
        );
      } else {
        Navigator.of(context).pop(); // Close loading dialog
        throw Exception('Failed to download CV: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Close loading dialog if it's still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('CV Preview Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Failed to preview CV: ${e.toString()}'),
                const SizedBox(height: 16),
                const Text(
                  'Trying to open CV in web view...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openCvInWebView(context, cvUrl, fileName ?? 'CV Preview');
                },
                child: const Text('Open in Web View'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openCvInBrowser(cvUrl);
                },
                child: const Text('Open in Browser'),
              ),
            ],
          );
        },
      );

      // Automatically try WebView after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Close error dialog
        }
        openCvInWebView(context, cvUrl, fileName ?? 'CV Preview');
      });
    }
  }

  static Future<void> _openCvInBrowser(String cvUrl) async {
    try {
      final uri = Uri.parse(cvUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch URL');
      }
    } catch (e) {
      print('Error opening CV in browser: $e');
    }
  }

  static Future<void> openCvInWebView(
    BuildContext context,
    String cvUrl,
    String fileName,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CvWebViewScreen(cvUrl: cvUrl, fileName: fileName),
      ),
    );
  }

  static Future<void> previewCvInWebView({
    required BuildContext context,
    required String cvUrl,
    String? fileName,
  }) async {
    // Direct WebView preview without trying PDF first
    openCvInWebView(context, cvUrl, fileName ?? 'CV Preview');
  }
}

class CvPreviewScreen extends StatelessWidget {
  final String filePath;
  final String fileName;
  final String cvUrl;

  const CvPreviewScreen({
    Key? key,
    required this.filePath,
    required this.fileName,
    required this.cvUrl,
  }) : super(key: key);

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
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        switch (value) {
                          case 'download':
                            _downloadCv(context);
                            break;
                          case 'share':
                            _shareCv(context);
                            break;
                          case 'open_browser':
                            CvPreviewService._openCvInBrowser(cvUrl);
                            break;
                        }
                      },
                      itemBuilder:
                          (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'download',
                              child: Row(
                                children: [
                                  Icon(Icons.download),
                                  SizedBox(width: 8),
                                  Text('Download'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'share',
                              child: Row(
                                children: [
                                  Icon(Icons.share),
                                  SizedBox(width: 8),
                                  Text('Share'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'open_browser',
                              child: Row(
                                children: [
                                  Icon(Icons.open_in_browser),
                                  SizedBox(width: 8),
                                  Text('Open in Browser'),
                                ],
                              ),
                            ),
                          ],
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF044463)),
            );
          }

          if (snapshot.hasError || !snapshot.data!) {
            // Automatically try WebView after a short delay
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context); // Close current screen
              CvPreviewService.openCvInWebView(context, cvUrl, fileName);
            });

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'CV file not found',
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
                  const Text(
                    'Opening in web view...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF044463),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(color: Color(0xFF044463)),
                ],
              ),
            );
          }

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'CV loaded successfully! Pages: ${details.document.pages.count}',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load CV: ${details.error}'),
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
      final file = File(filePath);
      final exists = await file.exists();
      return exists;
    } catch (e) {
      return false;
    }
  }

  void _downloadCv(BuildContext context) {
    // TODO: Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download functionality coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _shareCv(BuildContext context) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class CvWebViewScreen extends StatefulWidget {
  final String cvUrl;
  final String fileName;

  const CvWebViewScreen({
    super.key,
    required this.cvUrl,
    required this.fileName,
  });

  @override
  State<CvWebViewScreen> createState() => _CvWebViewScreenState();
}

class _CvWebViewScreenState extends State<CvWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar based on WebView progress
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.cvUrl));
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
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.fileName,
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
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        switch (value) {
                          case 'refresh':
                            _controller.reload();
                            break;
                          case 'open_browser':
                            CvPreviewService._openCvInBrowser(widget.cvUrl);
                            break;
                        }
                      },
                      itemBuilder:
                          (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'refresh',
                              child: Row(
                                children: [
                                  Icon(Icons.refresh),
                                  SizedBox(width: 8),
                                  Text('Refresh'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'open_browser',
                              child: Row(
                                children: [
                                  Icon(Icons.open_in_browser),
                                  SizedBox(width: 8),
                                  Text('Open in Browser'),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF044463)),
                  SizedBox(height: 16),
                  Text(
                    'Loading CV...',
                    style: TextStyle(color: Color(0xFF044463), fontSize: 16),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
