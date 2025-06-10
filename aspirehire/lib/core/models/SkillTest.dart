class GetQuizRequest {
  final String skill;

  GetQuizRequest({required this.skill});

  Map<String, dynamic> toJson() {
    return {'skill': skill};
  }
}

class QuizQuestion {
  final String skill;
  final String question;
  final List<String> options;

  QuizQuestion({
    required this.skill,
    required this.question,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      skill: json['skill'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
    );
  }
}

class GetQuizResponse {
  final String quizId;
  final List<QuizQuestion> quiz;

  GetQuizResponse({required this.quizId, required this.quiz});

  factory GetQuizResponse.fromJson(Map<String, dynamic> json) {
    return GetQuizResponse(
      quizId: json['quizId'] ?? '',
      quiz:
          (json['quiz'] as List<dynamic>?)
              ?.map((item) => QuizQuestion.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class SubmitQuizRequest {
  final List<String> answers;
  final String quizId;

  SubmitQuizRequest({required this.answers, required this.quizId});

  Map<String, dynamic> toJson() {
    return {'answers': answers, 'quizId': quizId};
  }
}

class SubmitQuizResponse {
  final bool success;
  final String message;
  final int score;

  SubmitQuizResponse({
    required this.success,
    required this.message,
    required this.score,
  });

  factory SubmitQuizResponse.fromJson(Map<String, dynamic> json) {
    return SubmitQuizResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      score: json['score'] ?? 0,
    );
  }
}
