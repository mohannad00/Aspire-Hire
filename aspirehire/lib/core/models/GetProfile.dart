class Profile {
  final String profileId;
  final String username;
  final String email;
  final String phone;
  final String? role; // Optional since it's not in the response
  final ProfilePicture? profilePicture; // Nullable profile picture object
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final List<String> skills;

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
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profileId'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'], // Optional, not in the provided response
      profilePicture:
          json['profilePicture'] != null
              ? ProfilePicture.fromJson(json['profilePicture'])
              : null,
      firstName: json['firstName'],
      lastName: json['lastName'],
      dob: json['dob'],
      gender: json['gender'],
      skills: List<String>.from(json['skills'] ?? []),
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
