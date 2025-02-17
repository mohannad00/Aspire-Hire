import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import '../../../../core/models/CreateJobPost.dart';
import 'create_job_post_state.dart';

class CreateJobPostCubit extends Cubit<CreateJobPostState> {
  CreateJobPostCubit() : super(CreateJobPostInitial());

  final Dio _dio = Dio();

  Future<void> createJobPost(CreateJobPostRequest request, String token) async {
    emit(CreateJobPostLoading());

    try {
      // Print the request being sent
      print('Sending Create Job Post Request: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.createJobPost,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Print the full response for debugging
      print('Create Job Post Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(CreateJobPostSuccess('Job post created successfully'));
      } else {
        emit(CreateJobPostFailure(response.data['message'] ?? 'Failed to create job post'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(CreateJobPostFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(CreateJobPostFailure('An unexpected error occurred: $e'));
    }
  }
}