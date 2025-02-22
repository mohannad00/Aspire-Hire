import 'dart:io';

class CreateJobApplicationRequest {
  final String jobPostId;
  final String coverLetter;
  final File attachment;

  CreateJobApplicationRequest({
    required this.jobPostId,
    required this.coverLetter,
    required this.attachment,
  });
}

class CreateJobApplicationResponse {
  final String id;
  final String jobPostId;
  final String coverLetter;
  final String attachmentPath;

  CreateJobApplicationResponse({
    required this.id,
    required this.jobPostId,
    required this.coverLetter,
    required this.attachmentPath,
  });

  factory CreateJobApplicationResponse.fromJson(Map<String, dynamic> json) {
    return CreateJobApplicationResponse(
      id: json['id'],
      jobPostId: json['jobPostId'],
      coverLetter: json['coverLetter'],
      attachmentPath: json['attachmentPath'],
    );
  }
}