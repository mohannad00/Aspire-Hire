import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import '../../../../config/datasources/api/end_points.dart';
import '../../../../core/models/GetJobApplications.dart';

part 'get_job_applications_state.dart';

class GetJobApplicationsCubit extends Cubit<GetJobApplicationsState> {
  GetJobApplicationsCubit() : super(GetJobApplicationsInitial());

  Future<void> getJobApplications({
    required String jobPostId,
    required String token,
  }) async {
    emit(GetJobApplicationsLoading());

    try {
      final dio = Dio();
      final response = await dio.get(
        ApiEndpoints.getJobApplications.replaceFirst(':jobPostId', jobPostId),
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200) {
        final responseModel = GetJobApplicationsResponse.fromJson(response.data);
        emit(GetJobApplicationsSuccess(responseModel));
      } else {
        emit(GetJobApplicationsFailure('Failed to load job applications'));
      }
    } catch (e) {
      emit(GetJobApplicationsFailure(e.toString()));
    }
  }
}