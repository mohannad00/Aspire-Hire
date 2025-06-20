import 'JobPost.dart';
import 'Feed.dart';

class CompanyProfileResponse {
  final bool success;
  final CompanyProfileData data;

  CompanyProfileResponse({required this.success, required this.data});

  factory CompanyProfileResponse.fromJson(Map<String, dynamic> json) {
    return CompanyProfileResponse(
      success: json['success'] ?? false,
      data: CompanyProfileData.fromJson(json['data']),
    );
  }
}

class CompanyProfileData {
  final CompanyUser user;
  final List<CompanyPost> posts;

  CompanyProfileData({required this.user, required this.posts});

  factory CompanyProfileData.fromJson(Map<String, dynamic> json) {
    return CompanyProfileData(
      user: CompanyUser.fromJson(json['user']),
      posts:
          (json['posts'] as List<dynamic>?)
              ?.where((postJson) => postJson is Map<String, dynamic>)
              .map(
                (postJson) =>
                    CompanyPost.fromJson(postJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class CompanyUser {
  final String profileId;
  final String username;
  final String email;
  final String phone;
  final String role;
  final CompanyProfilePicture? profilePicture;
  final String? address;
  final String companyName;
  final List<dynamic> jobApplications;
  final List<CompanyJobPost> jobPosts;

  CompanyUser({
    required this.profileId,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePicture,
    this.address,
    required this.companyName,
    required this.jobApplications,
    required this.jobPosts,
  });

  factory CompanyUser.fromJson(Map<String, dynamic> json) {
    return CompanyUser(
      profileId: json['profileId']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      profilePicture:
          json['profilePicture'] != null
              ? CompanyProfilePicture.fromJson(json['profilePicture'])
              : null,
      address: json['address']?.toString(),
      companyName: json['companyName']?.toString() ?? '',
      jobApplications:
          (json['jobApplications'] is List) ? json['jobApplications'] : [],
      jobPosts:
          (json['jobPosts'] is List)
              ? (json['jobPosts'] as List)
                  .map((jobJson) => CompanyJobPost.fromJson(jobJson))
                  .toList()
              : [],
    );
  }
}

class CompanyJobPost {
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
  final String applicationDeadline;
  final bool archived;
  final String fullAddress;
  final String createdAt;
  final String updatedAt;

  CompanyJobPost({
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
  });

  factory CompanyJobPost.fromJson(Map<String, dynamic> json) {
    return CompanyJobPost(
      id: json['_id']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      jobTitle: json['jobTitle']?.toString() ?? '',
      jobCategory: json['jobCategory']?.toString() ?? '',
      jobDescription: json['jobDescription']?.toString() ?? '',
      requiredSkills:
          (json['requiredSkills'] is List)
              ? (json['requiredSkills'] as List)
                  .map((e) => e.toString())
                  .toList()
              : [],
      location: json['location']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      salary:
          json['salary'] is int
              ? json['salary']
              : int.tryParse(json['salary']?.toString() ?? '') ?? 0,
      jobPeriod: json['jobPeriod']?.toString() ?? '',
      jobType: json['jobType']?.toString() ?? '',
      experience: json['experience']?.toString() ?? '',
      applicationDeadline: json['applicationDeadline']?.toString() ?? '',
      archived: json['archived'] == true,
      fullAddress: json['fullAddress']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}

class Company {
  final String profileId;
  final CompanyProfilePicture? profilePicture;
  final String companyName;

  Company({
    required this.profileId,
    this.profilePicture,
    required this.companyName,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    profileId: json['profileId'] as String,
    profilePicture:
        json['profilePicture'] != null
            ? CompanyProfilePicture.fromJson(
              json['profilePicture'] as Map<String, dynamic>,
            )
            : null,
    companyName: json['companyName'] as String,
  );

  Map<String, dynamic> toJson() => {
    'profileId': profileId,
    if (profilePicture != null) 'profilePicture': profilePicture!.toJson(),
    'companyName': companyName,
  };
}

class CompanyProfilePicture {
  final String? secureUrl;

  CompanyProfilePicture({this.secureUrl});

  factory CompanyProfilePicture.fromJson(Map<String, dynamic> json) =>
      CompanyProfilePicture(secureUrl: json['secure_url'] as String?);

  Map<String, dynamic> toJson() => {
    if (secureUrl != null) 'secure_url': secureUrl,
  };
}

class CompanyPost {
  // This should match the structure of your Post model from Feed.dart, but with a Company prefix for clarity
  // For now, just a placeholder
  final String id;
  final String content;
  // Add other fields as needed

  CompanyPost({required this.id, required this.content});

  factory CompanyPost.fromJson(Map<String, dynamic> json) {
    return CompanyPost(
      id: json['_id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }
}
