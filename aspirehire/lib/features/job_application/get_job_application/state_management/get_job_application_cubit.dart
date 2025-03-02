import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import '../../../../config/datasources/api/end_points.dart';
import '../../../../core/models/GetJobApplication.dart';

part 'get_job_application_state.dart';

class GetJobApplicationCubit extends Cubit<GetJobApplicationState> {
  GetJobApplicationCubit() : super(GetJobApplicationInitial());

  Future<void> getJobApplication({
    required String jobPostId,
    required String applicationId,
    required String token,
  }) async {
    emit(GetJobApplicationLoading());

    try {
      final dio = Dio();
      final response = await dio.get(
        ApiEndpoints.getJobApplication
            .replaceFirst(':jobPostId', jobPostId)
            .replaceFirst(':applicationId', applicationId),
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200) {
        final responseModel = GetJobApplicationResponse.fromJson(response.data);
        emit(GetJobApplicationSuccess(responseModel));
      } else {
        emit(GetJobApplicationFailure('Failed to load job application'));
      }
    } catch (e) {
      emit(GetJobApplicationFailure(e.toString()));
    }
  }
}
