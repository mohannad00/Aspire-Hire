import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import '../../../../config/datasources/api/end_points.dart';
import '../../../../core/models/CreateJobApplication.dart';

part 'create_job_application_state.dart';

class CreateJobApplicationCubit extends Cubit<CreateJobApplicationState> {
  CreateJobApplicationCubit() : super(CreateJobApplicationInitial());

  Future<void> createJobApplication({
    required String jobPostId,
    required String coverLetter,
    required File attachment,
    required String token,
  }) async {
    emit(CreateJobApplicationLoading());

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'coverLetter': coverLetter,
        'attachment': await MultipartFile.fromFile(attachment.path),
      });

      final response = await dio.post(
        ApiEndpoints.createJobApplication.replaceFirst(':jobPostId', jobPostId),
        data: formData,
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 201) {
        final responseModel = CreateJobApplicationResponse.fromJson(response.data);
        emit(CreateJobApplicationSuccess(responseModel));
      } else {
        emit(CreateJobApplicationFailure('Failed to create job application'));
      }
    } catch (e) {
      emit(CreateJobApplicationFailure(e.toString()));
    }
  }
}