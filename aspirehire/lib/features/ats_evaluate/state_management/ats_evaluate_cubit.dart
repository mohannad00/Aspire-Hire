import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/ATSEvaluation.dart';
import 'ats_evaluate_state.dart';

class ATSEvaluateCubit extends Cubit<ATSEvaluateState> {
  final Dio _dio = Dio();

  ATSEvaluateCubit() : super(ATSEvaluateInitial());

  Future<void> evaluateResume({
    required String resumeFilePath,
    required String jobDescription,
  }) async {
    emit(ATSEvaluateLoading());

    try {
      final formData = FormData.fromMap({
        'resume': await MultipartFile.fromFile(resumeFilePath),
        'job_description': jobDescription,
      });

      final response = await _dio.post(
        ApiEndpoints.evaluateResume,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        final evaluation = ATSEvaluation.fromJson(response.data);
        emit(ATSEvaluateSuccess(evaluation));
      } else {
        emit(ATSEvaluateFailure('Failed to evaluate resume'));
      }
    } catch (e) {
      emit(ATSEvaluateFailure(e.toString()));
    }
  }
}
