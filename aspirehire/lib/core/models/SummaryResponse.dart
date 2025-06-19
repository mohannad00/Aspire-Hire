import 'package:equatable/equatable.dart';

class SummaryResponse extends Equatable {
  final String summary;

  const SummaryResponse({required this.summary});

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(summary: json['summary'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'summary': summary};
  }

  @override
  List<Object?> get props => [summary];
}
