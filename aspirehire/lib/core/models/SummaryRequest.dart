import 'package:equatable/equatable.dart';

class SummaryRequest extends Equatable {
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
  final String tone;

  const SummaryRequest({
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
    required this.tone,
  });

  factory SummaryRequest.fromJson(Map<String, dynamic> json) {
    return SummaryRequest(
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
      tone: json['tone'] ?? '',
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
      'tone': tone,
    };
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    nationality,
    phone,
    dob,
    gender,
    education,
    skills,
    experience,
    language,
    jobTitle,
    company,
    hireDate,
    github,
    email,
    linkedin,
    tone,
  ];
}
