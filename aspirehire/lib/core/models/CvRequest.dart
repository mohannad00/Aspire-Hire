import 'package:equatable/equatable.dart';

class CvData {
  final String firstName;
  final String lastName;
  final String nationality;
  final String phone;
  final String dob;
  final String gender;
  final String education;
  final List<String> skills;
  final String experience;
  final String language;
  final String jobTitle;
  final String company;
  final String hireDate;
  final String github;
  final String email;
  final String linkedin;

  const CvData({
    required this.firstName,
    required this.lastName,
    required this.nationality,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.education,
    required this.skills,
    required this.experience,
    required this.language,
    required this.jobTitle,
    required this.company,
    required this.hireDate,
    required this.github,
    required this.email,
    required this.linkedin,
  });

  factory CvData.fromJson(Map<String, dynamic> json) {
    return CvData(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      nationality: json['nationality'] ?? '',
      phone: json['phone'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      education: json['education'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      experience: json['experience'] ?? '',
      language: json['language'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      company: json['company'] ?? '',
      hireDate: json['hireDate'] ?? '',
      github: json['github'] ?? '',
      email: json['email'] ?? '',
      linkedin: json['linkedin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nationality': nationality,
      'phone': phone,
      'dob': dob,
      'gender': gender,
      'education': education,
      'skills': skills,
      'experience': experience,
      'language': language,
      'jobTitle': jobTitle,
      'company': company,
      'hireDate': hireDate,
      'github': github,
      'email': email,
      'linkedin': linkedin,
    };
  }
}

class CvRequest extends Equatable {
  final CvData cvData;
  final String summary;
  final String themeColor;

  const CvRequest({
    required this.cvData,
    required this.summary,
    required this.themeColor,
  });

  factory CvRequest.fromJson(Map<String, dynamic> json) {
    return CvRequest(
      cvData: CvData.fromJson(json['cv_data'] ?? {}),
      summary: json['summary'] ?? '',
      themeColor: json['theme_color'] ?? '#AE06C1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cv_data': cvData.toJson(),
      'summary': summary,
      'theme_color': themeColor,
    };
  }

  @override
  List<Object?> get props => [cvData, summary, themeColor];
}
