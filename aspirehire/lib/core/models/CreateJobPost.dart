class CreateJobPostRequest {
  final String jobTitle;
  final String jobCategory;
  final String jobDescription;
  final List<String> requiredSkills;
  final String location;
  final String country;
  final String city;
  final int salary;
  final String jobPeriod;
  final String experience;
  final String applicationDeadline;
  final String jobType;

  CreateJobPostRequest({
    required this.jobTitle,
    required this.jobCategory,
    required this.jobDescription,
    required this.requiredSkills,
    required this.location,
    required this.country,
    required this.city,
    required this.salary,
    required this.jobPeriod,
    required this.experience,
    required this.applicationDeadline,
    required this.jobType,
  });

  Map<String, dynamic> toJson() => {
    "jobTitle": jobTitle,
    "jobCategory": jobCategory,
    "jobDescription": jobDescription,
    "requiredSkills": requiredSkills,
    "location": location,
    "country": country,
    "city": city,
    "salary": salary,
    "jobPeriod": jobPeriod,
    "experience": experience,
    "applicationDeadline": applicationDeadline,
    "jobType": jobType,
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

  factory CreateJobPostResponse.fromJson(Map<String, dynamic> json) =>
      CreateJobPostResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"],
      );
}

class JobPostData {
  final String? companyId;
  final String jobTitle;
  final String jobCategory;
  final String jobDescription;
  final List<String> requiredSkills;
  final String location;
  final String country;
  final String city;
  final int salary;
  final String jobPeriod;
  final String experience;
  final DateTime applicationDeadline;
  final String jobType;
  final bool archived;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fullAddress;

  JobPostData({
    this.companyId,
    required this.jobTitle,
    required this.jobCategory,
    required this.jobDescription,
    required this.requiredSkills,
    required this.location,
    required this.country,
    required this.city,
    required this.salary,
    required this.jobPeriod,
    required this.experience,
    required this.applicationDeadline,
    required this.jobType,
    required this.archived,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.fullAddress,
  });

  factory JobPostData.fromJson(Map<String, dynamic> json) {
    return JobPostData(
      companyId: json['companyId'],
      jobTitle: json['jobTitle'] ?? '',
      jobCategory: json['jobCategory'] ?? '',
      jobDescription: json['jobDescription'] ?? '',
      requiredSkills:
          json['requiredSkills'] != null
              ? List<String>.from(json['requiredSkills'])
              : [],
      location: json['location'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      salary: json['salary'] ?? 0,
      jobPeriod: json['jobPeriod'] ?? '',
      experience: json['experience'] ?? '',
      applicationDeadline:
          json['applicationDeadline'] != null
              ? DateTime.parse(json['applicationDeadline'])
              : DateTime.now(),
      jobType: json['jobType'] ?? '',
      archived: json['archived'] ?? false,
      id: json['_id'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      fullAddress: json['fullAddress'],
    );
  }
}

/*
  {
    "success": true,
    "message": "Job post is created successfully",
    "data": {
        "company": "67b9d0acc9a3deef9f2dccb0",
        "jobTitle": "Frontend Engineer",
        "jobDescription": "Job Title: Frontend Engineer\nLorem ipsum dolor sit, amet consectetur adipisicing elit. Aperiam facilis omnis repellendus",
        "requiredSkills": [
            "Node.js"
        ],
        "location": "12 hola st.",
        "country": "Egypt",
        "salary": 4000,
        "jobPeriod": "PartTime",
        "experience": "Intermediate",
        "applicationDeadline": "2025-03-01T00:00:00.000Z",
        "archived": false,
        "_id": "67b9d99ac9a3deef9f2dccc8",
        "createdAt": "2025-02-22T14:05:14.970Z",
        "updatedAt": "2025-02-22T14:05:14.970Z",
        "id": "67b9d99ac9a3deef9f2dccc8"
    }
}
 */
