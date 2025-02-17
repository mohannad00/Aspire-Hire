import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import 'delete_job_post_state.dart';

class DeleteJobPostCubit extends Cubit<DeleteJobPostState> {
  DeleteJobPostCubit() : super(DeleteJobPostInitial());

  final Dio _dio = Dio();

  Future<void> deleteJobPost(String jobPostId, String token) async {
    emit(DeleteJobPostLoading());

    try {
      // Print the job post ID being deleted
      print('Deleting Job Post with ID: $jobPostId');

      final response = await _dio.delete(
        '${ApiEndpoints.deleteJobPost}/$jobPostId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Print the full response for debugging
      print('Delete Job Post Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(DeleteJobPostSuccess('Job post deleted successfully'));
      } else {
        emit(DeleteJobPostFailure(response.data['message'] ?? 'Failed to delete job post'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(DeleteJobPostFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(DeleteJobPostFailure('An unexpected error occurred: $e'));
    }
  }
}