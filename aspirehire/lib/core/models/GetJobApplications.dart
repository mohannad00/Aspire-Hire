import 'package:aspirehire/core/models/GetJobApplication.dart';

class GetJobApplicationsRequest {
  final String jobPostId;

  GetJobApplicationsRequest({
    required this.jobPostId,
  });
}

class GetJobApplicationsResponse {
  final List<GetJobApplicationResponse> applications;

  GetJobApplicationsResponse({required this.applications});

  factory GetJobApplicationsResponse.fromJson(List<dynamic> json) {
    return GetJobApplicationsResponse(
      applications: json.map((e) => GetJobApplicationResponse.fromJson(e)).toList(),
    );
  }
}