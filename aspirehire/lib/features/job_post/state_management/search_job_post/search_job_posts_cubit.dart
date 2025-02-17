import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import 'search_job_posts_state.dart';

class SearchJobPostsCubit extends Cubit<SearchJobPostsState> {
  SearchJobPostsCubit() : super(SearchJobPostsInitial());

  final Dio _dio = Dio();

  Future<void> searchJobPosts(Map<String, dynamic> filters, String token) async {
    emit(SearchJobPostsLoading());

    try {
      // Print the filters being used
      print('Searching Job Posts with Filters: $filters');

      final response = await _dio.get(
        ApiEndpoints.searchJobPosts,
        queryParameters: filters,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Print the full response for debugging
      print('Search Job Posts Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(SearchJobPostsSuccess(List<Map<String, dynamic>>.from(response.data)));
      } else {
        emit(SearchJobPostsFailure(response.data['message'] ?? 'Failed to search job posts'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(SearchJobPostsFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(SearchJobPostsFailure('An unexpected error occurred: $e'));
    }
  }
}