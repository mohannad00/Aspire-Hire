import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import '../../../../config/database/api/end_points.dart';
import '../../../../core/models/UpdateJobApplication.dart';

part 'update_job_application_state.dart';

class UpdateJobApplicationCubit extends Cubit<UpdateJobApplicationState> {
  UpdateJobApplicationCubit() : super(UpdateJobApplicationInitial());

  Future<void> updateJobApplication({
    required String jobPostId,
    required String applicationId,
    required String respond,
    required String token,
  }) async {
    emit(UpdateJobApplicationLoading());

    try {
      final dio = Dio();
      final response = await dio.post(
        ApiEndpoints.updateJobApplication
            .replaceFirst(':jobPostId', jobPostId)
            .replaceFirst(':applicationId', applicationId),
        data: {'respond': respond},
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200) {
        final responseModel = UpdateJobApplicationResponse.fromJson(response.data);
        emit(UpdateJobApplicationSuccess(responseModel));
      } else {
        emit(UpdateJobApplicationFailure('Failed to update job application'));
      }
    } catch (e) {
      emit(UpdateJobApplicationFailure(e.toString()));
    }
  }
}