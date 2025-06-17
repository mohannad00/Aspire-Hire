class Company {
  final String profileId;
  final ProfilePicture? profilePicture;
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
            ? ProfilePicture.fromJson(
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

class ProfilePicture {
  final String? secureUrl;

  ProfilePicture({this.secureUrl});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) =>
      ProfilePicture(secureUrl: json['secure_url'] as String?);

  Map<String, dynamic> toJson() => {
    if (secureUrl != null) 'secure_url': secureUrl,
  };
}
