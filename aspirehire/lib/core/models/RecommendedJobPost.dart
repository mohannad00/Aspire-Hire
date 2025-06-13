class RecommendedJobPostResponse {
  final bool success;
  final List<RecommendedJobData> data;

  RecommendedJobPostResponse({required this.success, required this.data});

  factory RecommendedJobPostResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedJobPostResponse(
      success: json["success"],
      data: List<RecommendedJobData>.from(
        json["data"].map((x) => RecommendedJobData.fromJson(x)),
      ),
    );
  }
}

class RecommendedJobData {
  final JobPost job;
  final String score;
  final List<String> matchedSkills;
  final String matchPercentage;

  RecommendedJobData({
    required this.job,
    required this.score,
    required this.matchedSkills,
    required this.matchPercentage,
  });

  factory RecommendedJobData.fromJson(Map<String, dynamic> json) {
    return RecommendedJobData(
      job: JobPost.fromJson(json["job"]),
      score: json["score"],
      matchedSkills: List<String>.from(json["matchedSkills"]),
      matchPercentage: json["matchPercentage"],
    );
  }
}

class JobPost {
  final String id;
  final String companyId;
  final String jobTitle;
  final String jobCategory;
  final String jobDescription;
  final List<String> requiredSkills;
  final String location;
  final String country;
  final String city;
  final int salary;
  final String jobPeriod;
  final String jobType;
  final String experience;
  final DateTime applicationDeadline;
  final bool archived;
  final String fullAddress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Company> company;

  JobPost({
    required this.id,
    required this.companyId,
    required this.jobTitle,
    required this.jobCategory,
    required this.jobDescription,
    required this.requiredSkills,
    required this.location,
    required this.country,
    required this.city,
    required this.salary,
    required this.jobPeriod,
    required this.jobType,
    required this.experience,
    required this.applicationDeadline,
    required this.archived,
    required this.fullAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.company,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json["_id"],
      companyId: json["companyId"],
      jobTitle: json["jobTitle"],
      jobCategory: json["jobCategory"],
      jobDescription: json["jobDescription"],
      requiredSkills: List<String>.from(json["requiredSkills"]),
      location: json["location"],
      country: json["country"],
      city: json["city"],
      salary: json["salary"],
      jobPeriod: json["jobPeriod"],
      jobType: json["jobType"],
      experience: json["experience"],
      applicationDeadline: DateTime.parse(json["applicationDeadline"]),
      archived: json["archived"],
      fullAddress: json["fullAddress"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      company: List<Company>.from(
        json["company"].map((x) => Company.fromJson(x)),
      ),
    );
  }
}

class Company {
  final String profileId;
  final ProfilePicture profilePicture;
  final String companyName;

  Company({
    required this.profileId,
    required this.profilePicture,
    required this.companyName,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      profileId: json["profileId"],
      profilePicture: ProfilePicture.fromJson(json["profilePicture"]),
      companyName: json["companyName"],
    );
  }
}

class ProfilePicture {
  final String secureUrl;

  ProfilePicture({required this.secureUrl});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(secureUrl: json["secure_url"]);
  }
}
