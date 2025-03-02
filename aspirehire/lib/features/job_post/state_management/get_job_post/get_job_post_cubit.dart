import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/datasources/api/end_points.dart';
import 'get_job_post_state.dart';

class GetJobPostCubit extends Cubit<GetJobPostState> {
  GetJobPostCubit() : super(GetJobPostInitial());

  final Dio _dio = Dio();

  Future<void> getJobPost(String jobPostId, String token) async {
    emit(GetJobPostLoading());

    try {
      // Print the job post ID being fetched
      print('Fetching Job Post with ID: $jobPostId');

      final response = await _dio.get(
        '${ApiEndpoints.getJobPost}/$jobPostId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
          },
        ),
      );

      // Print the full response for debugging
      print('Get Job Post Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(GetJobPostSuccess(response.data));
      } else {
        emit(GetJobPostFailure(response.data['message'] ?? 'Failed to fetch job post'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(GetJobPostFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(GetJobPostFailure('An unexpected error occurred: $e'));
    }
  }
}