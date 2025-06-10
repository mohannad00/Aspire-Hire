import '../../../core/models/SkillTest.dart';

abstract class SkillTestState {}

class SkillTestInitial extends SkillTestState {}

class SkillTestLoading extends SkillTestState {}

class QuizLoaded extends SkillTestState {
  final GetQuizResponse quizResponse;

  QuizLoaded(this.quizResponse);
}

class QuizSubmitted extends SkillTestState {
  final SubmitQuizResponse submitResponse;

  QuizSubmitted(this.submitResponse);
}

class SkillTestError extends SkillTestState {
  final String message;

  SkillTestError(this.message);
}
