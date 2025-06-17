import 'Feed.dart';
import 'GetProfile.dart' as profile;

class UserProfileResponse {
  final bool success;
  final UserProfileData data;

  UserProfileResponse({required this.success, required this.data});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] ?? false,
      data: UserProfileData.fromJson(json['data']),
    );
  }
}

class UserProfileData {
  final UserProfile user;
  final List<Post> posts;

  UserProfileData({required this.user, required this.posts});

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      user: UserProfile.fromJson(json['user']),
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((postJson) => Post.fromJson(postJson))
              .toList() ??
          [],
    );
  }
}

class UserProfile {
  final String profileId;
  final String username;
  final String email;
  final String phone;
  final String role;
  final ProfilePicture? profilePicture;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final List<String> friendRequestsSentIds;
  final List<profile.Education> education;
  final List<profile.Skill> skills;
  final List<profile.Experience> experience;
  final Resume? resume;
  final String? resumeText;
  final List<dynamic> jobPosts;
  final List<JobApplication> jobApplications;
  final String? github;
  final String? twitter;

  UserProfile({
    required this.profileId,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.friendRequestsSentIds,
    required this.education,
    required this.skills,
    required this.experience,
    this.resume,
    this.resumeText,
    required this.jobPosts,
    required this.jobApplications,
    this.github,
    this.twitter,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profileId: json['profileId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      profilePicture:
          json['profilePicture'] != null
              ? ProfilePicture.fromJson(json['profilePicture'])
              : null,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      friendRequestsSentIds: List<String>.from(
        json['friendRequestsSentIds'] ?? [],
      ),
      education:
          (json['education'] as List<dynamic>?)
              ?.map((eduJson) => profile.Education.fromJson(eduJson))
              .toList() ??
          [],
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((skillJson) => profile.Skill.fromJson(skillJson))
              .toList() ??
          [],
      experience:
          (json['experience'] as List<dynamic>?)
              ?.map((expJson) => profile.Experience.fromJson(expJson))
              .toList() ??
          [],
      resume: json['resume'] != null ? Resume.fromJson(json['resume']) : null,
      resumeText: json['resumeText'],
      jobPosts: json['jobPosts'] ?? [],
      jobApplications:
          (json['jobApplications'] as List<dynamic>?)
              ?.map((appJson) => JobApplication.fromJson(appJson))
              .toList() ??
          [],
      github: json['github'],
      twitter: json['twitter'] ?? json['x'],
    );
  }
}

class Resume {
  final String publicId;
  final String secureUrl;

  Resume({required this.publicId, required this.secureUrl});

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      publicId: json['public_id'] ?? '',
      secureUrl: json['secure_url'] ?? '',
    );
  }
}

class JobApplication {
  final String id;
  final JobPost jobPost;
  final String employeeId;
  final String coverLetter;
  final Resume resume;
  final String status;
  final String createdAt;
  final String updatedAt;

  JobApplication({
    required this.id,
    required this.jobPost,
    required this.employeeId,
    required this.coverLetter,
    required this.resume,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['_id'] ?? '',
      jobPost: JobPost.fromJson(json['jobPost']),
      employeeId: json['employeeId'] ?? '',
      coverLetter: json['coverLetter'] ?? '',
      resume: Resume.fromJson(json['resume']),
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class JobPost {
  final String id;
  final String companyId;
  final String jobTitle;
  final List<Company> company;

  JobPost({
    required this.id,
    required this.companyId,
    required this.jobTitle,
    required this.company,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['_id'] ?? '',
      companyId: json['companyId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      company:
          (json['company'] as List<dynamic>?)
              ?.map((companyJson) => Company.fromJson(companyJson))
              .toList() ??
          [],
    );
  }
}

class Company {
  final String profileId;
  final ProfilePicture? profilePicture;
  final String companyName;

  Company({
    required this.profileId,
    this.profilePicture,
    required this.companyName,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      profileId: json['profileId'] ?? '',
      profilePicture:
          json['profilePicture'] != null
              ? ProfilePicture.fromJson(json['profilePicture'])
              : null,
      companyName: json['companyName'] ?? '',
    );
  }
}
