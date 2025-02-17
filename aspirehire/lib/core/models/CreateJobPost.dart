class CreateJobPostRequest {
  final String jobTitle;
  final String jobDescription;
  final List<String> requiredSkills;
  final String location;
  final String country;
  final int salary;
  final String jobPeriod;
  final String experience;
  final String applicationDeadline;


  CreateJobPostRequest({
    required this.jobTitle,
    required this.jobDescription,
    required this.requiredSkills,
    required this.location,
    required this.country,
    required this.salary,
    required this.jobPeriod,
    required this.experience,
    required this.applicationDeadline,
  });

  Map<String, dynamic> toJson() => {
    "jobTitle": jobTitle,
    "jobDescription": jobDescription,
    "requiredSkills": requiredSkills,
    "location": location,
    "country": country,
    "salary": salary,
    "jobPeriod": jobPeriod,
    "experience": experience,
    "applicationDeadline": applicationDeadline,
  };
}

class CreateJobPostResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  CreateJobPostResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateJobPostResponse.fromJson(Map<String, dynamic> json) => CreateJobPostResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"],
  );
}