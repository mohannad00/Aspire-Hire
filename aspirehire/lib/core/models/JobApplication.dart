class JobApplication {
  final String id;
  final JobPostInfo jobPost;
  final String employeeId;
  final String coverLetter;
  final Resume resume;
  final String status;
  final DateTime createdAt;
  final List<Employee> employee;

  JobApplication({
    required this.id,
    required this.jobPost,
    required this.employeeId,
    required this.coverLetter,
    required this.resume,
    required this.status,
    required this.createdAt,
    required this.employee,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    // Handle jobPost field which can be either a string (ID) or an object
    JobPostInfo jobPostInfo;
    if (json['jobPost'] is String) {
      // If jobPost is a string (ID), create a JobPostInfo with just the ID
      jobPostInfo = JobPostInfo(id: json['jobPost'], jobTitle: '');
    } else if (json['jobPost'] is Map<String, dynamic>) {
      // If jobPost is an object, parse it normally
      jobPostInfo = JobPostInfo.fromJson(json['jobPost']);
    } else {
      // Fallback to empty JobPostInfo
      jobPostInfo = JobPostInfo(id: '', jobTitle: '');
    }

    return JobApplication(
      id: json['_id'] ?? '',
      jobPost: jobPostInfo,
      employeeId: json['employeeId'] ?? '',
      coverLetter: json['coverLetter'] ?? '',
      resume: Resume.fromJson(json['resume'] ?? {}),
      status: json['status'] ?? 'Pending',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      employee:
          json['employee'] != null
              ? (json['employee'] as List)
                  .map((e) => Employee.fromJson(e))
                  .toList()
              : [],
    );
  }
}

class JobPostInfo {
  final String id;
  final String jobTitle;

  JobPostInfo({required this.id, required this.jobTitle});

  factory JobPostInfo.fromJson(Map<String, dynamic> json) {
    return JobPostInfo(id: json['_id'] ?? '', jobTitle: json['jobTitle'] ?? '');
  }
}

class Resume {
  final String secureUrl;
  final String publicId;

  Resume({required this.secureUrl, required this.publicId});

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      secureUrl: json['secure_url'] ?? '',
      publicId: json['public_id'] ?? '',
    );
  }
}

class Employee {
  final String profileId;
  final String role;
  final ProfilePicture? profilePicture;
  final String firstName;
  final String lastName;

  Employee({
    required this.profileId,
    required this.role,
    this.profilePicture,
    required this.firstName,
    required this.lastName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      profileId: json['profileId'] ?? '',
      role: json['role'] ?? '',
      profilePicture:
          json['profilePicture'] != null
              ? ProfilePicture.fromJson(json['profilePicture'])
              : null,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}

class ProfilePicture {
  final String secureUrl;

  ProfilePicture({required this.secureUrl});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(secureUrl: json['secure_url'] ?? '');
  }
}
