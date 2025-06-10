class Profile {
  final String profileId;
  final String username;
  final String email;
  final String phone;
  final String? role;
  final ProfilePicture? profilePicture;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final List<Skill> skills;
  final List<String> friendRequestsSentIds; // Added
  final List<dynamic> education; // Added, using dynamic for flexibility
  final List<dynamic> experience; // Added, using dynamic for flexibility
  final List<dynamic> jobApplications; // Added, using dynamic for flexibility
  final List<dynamic> jobPosts; // Added, using dynamic for flexibility

  Profile({
    required this.profileId,
    required this.username,
    required this.email,
    required this.phone,
    this.role,
    this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.skills,
    required this.friendRequestsSentIds,
    required this.education,
    required this.experience,
    required this.jobApplications,
    required this.jobPosts,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profileId'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      profilePicture:
          json['profilePicture'] != null
              ? ProfilePicture.fromJson(json['profilePicture'])
              : null,
      firstName: json['firstName'],
      lastName: json['lastName'],
      dob: json['dob'],
      gender: json['gender'],
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((skillJson) => Skill.fromJson(skillJson))
              .toList() ??
          [],
      friendRequestsSentIds: List<String>.from(
        json['friendRequestsSentIds'] ?? [],
      ),
      education: json['education'] ?? [],
      experience: json['experience'] ?? [],
      jobApplications: json['jobApplications'] ?? [],
      jobPosts: json['jobPosts'] ?? [],
    );
  }
}

class ProfilePicture {
  final String publicId;
  final String secureUrl;

  ProfilePicture({required this.publicId, required this.secureUrl});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      publicId: json['public_id'],
      secureUrl: json['secure_url'],
    );
  }
}

class Skill {
  final String skill; // Changed from 'name' to 'skill'
  final bool verified;
  final String id; // Changed from '_id' to 'id' for Dart naming convention

  Skill({required this.skill, required this.verified, required this.id});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      skill: json['skill'],
      verified: json['verified'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'skill': skill, 'verified': verified, '_id': id};
  }
}
