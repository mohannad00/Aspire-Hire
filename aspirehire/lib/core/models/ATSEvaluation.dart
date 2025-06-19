import 'package:equatable/equatable.dart';

class ATSEvaluation extends Equatable {
  final List<String> improvements;
  final int matchPercentage;
  final List<String> missingSkills;
  final List<String> strengths;

  const ATSEvaluation({
    required this.improvements,
    required this.matchPercentage,
    required this.missingSkills,
    required this.strengths,
  });

  factory ATSEvaluation.fromJson(Map<String, dynamic> json) {
    return ATSEvaluation(
      improvements: List<String>.from(json['improvements'] ?? []),
      matchPercentage: json['match_percentage'] ?? 0,
      missingSkills: List<String>.from(json['missing_skills'] ?? []),
      strengths: List<String>.from(json['strengths'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'improvements': improvements,
      'match_percentage': matchPercentage,
      'missing_skills': missingSkills,
      'strengths': strengths,
    };
  }

  @override
  List<Object?> get props => [
    improvements,
    matchPercentage,
    missingSkills,
    strengths,
  ];
}
