import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import '../../../../core/models/UpdateJobPost.dart';
import 'update_job_post_state.dart';

class UpdateJobPostCubit extends Cubit<UpdateJobPostState> {
  UpdateJobPostCubit() : super(UpdateJobPostInitial());

  final Dio _dio = Dio();

  Future<void> updateJobPost(String jobPostId, UpdateJobPostRequest request, String token) async {
    emit(UpdateJobPostLoading());

    try {
      // Print the request being sent
      print('Sending Update Job Post Request: ${request.toJson()}');

      final response = await _dio.put(
        '${ApiEndpoints.updateJobPost}/$jobPostId',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token ,
          },
        ),
      );

      // Print the full response for debugging
      print('Update Job Post Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(UpdateJobPostSuccess('Job post updated successfully'));
      } else {
        emit(UpdateJobPostFailure(response.data['message'] ?? 'Failed to update job post'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(UpdateJobPostFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(UpdateJobPostFailure('An unexpected error occurred: $e'));
    }
  }
}