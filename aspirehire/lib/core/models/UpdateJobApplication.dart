class UpdateJobApplicationRequest {
  final String jobPostId;
  final String applicationId;
  final bool respond;

  UpdateJobApplicationRequest({
    required this.jobPostId,
    required this.applicationId,
    required this.respond,
  });

  Map<String, dynamic> toJson() {
    return {'respond': respond};
  }
}

class UpdateJobApplicationResponse {
  final String id;
  final bool respond;

  UpdateJobApplicationResponse({required this.id, required this.respond});

  factory UpdateJobApplicationResponse.fromJson(Map<String, dynamic> json) {
    return UpdateJobApplicationResponse(
      id: json['id'],
      respond: json['respond'] ?? false,
    );
  }
}
