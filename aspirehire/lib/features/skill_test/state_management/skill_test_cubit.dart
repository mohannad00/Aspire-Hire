import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/SkillTest.dart';
import 'skill_test_state.dart';

class SkillTestCubit extends Cubit<SkillTestState> {
  final Dio _dio = Dio();

  SkillTestCubit() : super(SkillTestInitial());

  // Get Quiz
  Future<void> getQuiz(String token, String skill) async {
    emit(SkillTestLoading());
    try {
      print('@@@Get Quiz Request: $skill');
      print('###Get Quiz Request: $token');
      final request = GetQuizRequest(skill: skill);
      print('Get Quiz Request: ${request.toJson()}');
      final response = await _dio.get(
        ApiEndpoints.getQuiz,
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );

      print('Get Quiz Response: ${response.data}');

      if (response.data['success'] == true) {
        final quizResponse = GetQuizResponse.fromJson(response.data['data']);
        emit(QuizLoaded(quizResponse));
      } else {
        emit(SkillTestError(response.data['message'] ?? 'Failed to load quiz'));
      }
    } on DioException catch (e) {
      print('DioException in getQuiz: ${e.message}');
      print('Response: ${e.response?.data}');

      String errorMessage = 'An error occurred';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(SkillTestError(errorMessage));
    } catch (e) {
      print('Unexpected error in getQuiz: $e');
      emit(SkillTestError('Unexpected error: $e'));
    }
  }

  // Submit Quiz
  Future<void> submitQuiz(
    String token,
    List<String> answers,
    String quizId,
  ) async {
    emit(SkillTestLoading());
    try {
      final request = SubmitQuizRequest(answers: answers, quizId: quizId);
      final response = await _dio.post(
        ApiEndpoints.submitQuiz,
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );

      print('Submit Quiz Response: ${response.data}');

      if (response.data['success'] == true) {
        final submitResponse = SubmitQuizResponse.fromJson(response.data);
        emit(QuizSubmitted(submitResponse));
      } else {
        emit(
          SkillTestError(response.data['message'] ?? 'Failed to submit quiz'),
        );
      }
    } on DioException catch (e) {
      print('DioException in submitQuiz: ${e.message}');
      print('Response: ${e.response?.data}');

      String errorMessage = 'An error occurred';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(SkillTestError(errorMessage));
    } catch (e) {
      print('Unexpected error in submitQuiz: $e');
      emit(SkillTestError('Unexpected error: $e'));
    }
  }
}
