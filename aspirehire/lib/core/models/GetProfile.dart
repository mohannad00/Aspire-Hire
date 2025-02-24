class Profile {
  final String profileId;
  final String username;
  final String email;
  final String phone;
  final String role;
  final String? profilePicture; // Nullable profile picture
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
    required this.role,
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
      role: json['role'],
      profilePicture: json['profilePicture'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dob: json['dob'],
      gender: json['gender'],
      skills: List<String>.from(json['skills'] ?? []),
    );
  }
}