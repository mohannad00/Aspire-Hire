import 'Company.dart';

class JobPost {
  final String id;
  final String companyId;
  final String jobTitle;
  final List<Company> company;

  JobPost({
    required this.id,
    required this.companyId,
    required this.jobTitle,
    required this.company,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) => JobPost(
    id: json['_id'] as String,
    companyId: json['companyId'] as String,
    jobTitle: json['jobTitle'] as String,
    company:
        (json['company'] as List<dynamic>)
            .map((e) => Company.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'companyId': companyId,
    'jobTitle': jobTitle,
    'company': company.map((e) => e.toJson()).toList(),
  };
}
