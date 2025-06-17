import 'JobPost.dart';
import 'Resume.dart';

class Application {
  final String id;
  final JobPost jobPost;
  final String employeeId;
  final String coverLetter;
  final Resume resume;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Application({
    required this.id,
    required this.jobPost,
    required this.employeeId,
    required this.coverLetter,
    required this.resume,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        id: json['_id'] as String,
        jobPost: JobPost.fromJson(json['jobPost'] as Map<String, dynamic>),
        employeeId: json['employeeId'] as String,
        coverLetter: json['coverLetter'] as String,
        resume: Resume.fromJson(json['resume'] as Map<String, dynamic>),
        status: json['status'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'jobPost': jobPost.toJson(),
        'employeeId': employeeId,
        'coverLetter': coverLetter,
        'resume': resume.toJson(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
} 