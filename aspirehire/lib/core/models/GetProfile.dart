class Profile {
  final String email;
  final String? profilePictureUrl;
  final String? resumeUrl;

  Profile({required this.email, this.profilePictureUrl, this.resumeUrl});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'],
      resumeUrl: json['resumeUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'resumeUrl': resumeUrl,
    };
  }
}