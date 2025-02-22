class GetJobApplicationRequest {
  final String jobPostId;
  final String applicationId;

  GetJobApplicationRequest({
    required this.jobPostId,
    required this.applicationId,
  });
}


class GetJobApplicationResponse {
  final String id;
  final String jobPostId;
  final String coverLetter;
  final String attachmentPath;
  final String? response;

  GetJobApplicationResponse({
    required this.id,
    required this.jobPostId,
    required this.coverLetter,
    required this.attachmentPath,
    this.response,
  });

  factory GetJobApplicationResponse.fromJson(Map<String, dynamic> json) {
    return GetJobApplicationResponse(
      id: json['id'],
      jobPostId: json['jobPostId'],
      coverLetter: json['coverLetter'],
      attachmentPath: json['attachmentPath'],
      response: json['response'],
    );
  }
}