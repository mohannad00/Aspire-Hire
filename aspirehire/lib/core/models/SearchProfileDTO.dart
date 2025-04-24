class UserProfile {
  final String profileId;
  final String username;
  final String role;
  final ProfilePicture? profilePicture;
  final String? firstName;
  final String? lastName;
  final String? companyName;

  UserProfile({
    required this.profileId,
    required this.username,
    required this.role,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.companyName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profileId: json['profileId'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      profilePicture: json['profilePicture'] != null
          ? ProfilePicture.fromJson(json['profilePicture'])
          : null,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      companyName: json['companyName'] as String?,
    );
  }
}

class ProfilePicture {
  final String secureUrl;

  ProfilePicture({required this.secureUrl});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      secureUrl: json['secure_url'] as String,
    );
  }
}