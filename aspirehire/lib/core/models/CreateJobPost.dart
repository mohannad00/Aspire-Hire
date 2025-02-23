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

class JobPostData {
  final String company;
  final String jobTitle;
  final String jobDescription;
  final List<String> requiredSkills;
  final String location;
  final String country;
  final int salary;
  final String jobPeriod;
  final String experience;
  final DateTime applicationDeadline;
  final bool archived;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobPostData({
    required this.company,
    required this.jobTitle,
    required this.jobDescription,
    required this.requiredSkills,
    required this.location,
    required this.country,
    required this.salary,
    required this.jobPeriod,
    required this.experience,
    required this.applicationDeadline,
    required this.archived,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobPostData.fromJson(Map<String, dynamic> json) {
    return JobPostData(
      company: json['company'],
      jobTitle: json['jobTitle'],
      jobDescription: json['jobDescription'],
      requiredSkills: List<String>.from(json['requiredSkills']),
      location: json['location'],
      country: json['country'],
      salary: json['salary'],
      jobPeriod: json['jobPeriod'],
      experience: json['experience'],
      applicationDeadline: DateTime.parse(json['applicationDeadline']),
      archived: json['archived'],
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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