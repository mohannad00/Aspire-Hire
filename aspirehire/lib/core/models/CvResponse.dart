import 'package:equatable/equatable.dart';

class CvResponse extends Equatable {
  final List<int> pdfData;
  final String fileName;

  const CvResponse({required this.pdfData, required this.fileName});

  factory CvResponse.fromBytes(List<int> bytes) {
    print('DEBUG: CvResponse.fromBytes called');
    print('DEBUG: Input bytes length: ${bytes.length}');
    print('DEBUG: Input bytes type: ${bytes.runtimeType}');

    // Check if bytes look like PDF (should start with %PDF)
    if (bytes.isNotEmpty) {
      final header = String.fromCharCodes(bytes.take(4));
      print('DEBUG: File header: $header');
      print('DEBUG: Is PDF header: ${header == '%PDF'}');
    }

    final fileName = 'cv_${DateTime.now().millisecondsSinceEpoch}.pdf';
    print('DEBUG: Generated file name: $fileName');

    final response = CvResponse(pdfData: bytes, fileName: fileName);

    print('DEBUG: CvResponse created with ${response.pdfData.length} bytes');
    return response;
  }

  @override
  List<Object?> get props => [pdfData, fileName];
}
