import 'GetProfile.dart';

class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? dob;
  final String? gender;
  final List<Skill>? skills;
  final List<dynamic>? education;
  final List<dynamic>? experience;
  final String? github;
  final String? twitter;

  UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.dob,
    this.gender,
    this.skills,
    this.education,
    this.experience,
    this.github,
    this.twitter,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (firstName != null) json['firstName'] = firstName;
    if (lastName != null) json['lastName'] = lastName;
    if (email != null) json['email'] = email;
    if (phone != null) json['phone'] = phone;
    if (dob != null) json['dob'] = dob;
    if (gender != null) json['gender'] = gender;
    if (skills != null)
      json['skills'] = skills!.map((skill) => skill.toJson()).toList();
    if (education != null) json['education'] = education;
    if (experience != null) json['experience'] = experience;
    if (github != null) json['github'] = github;
    if (twitter != null) json['twitter'] = twitter;

    return json;
  }
}

class UpdateSkillsRequest {
  final List<String> skills;

  UpdateSkillsRequest({required this.skills});

  Map<String, dynamic> toJson() {
    return {'skills': skills};
  }
}
