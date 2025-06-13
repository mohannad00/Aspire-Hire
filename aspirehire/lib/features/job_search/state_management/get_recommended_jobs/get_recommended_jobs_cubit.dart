import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/datasources/api/end_points.dart';
import '../../../../core/models/RecommendedJobPost.dart';
import 'get_recommended_jobs_state.dart';

class GetRecommendedJobsCubit extends Cubit<GetRecommendedJobsState> {
  GetRecommendedJobsCubit() : super(GetRecommendedJobsInitial());

  final Dio _dio = Dio();

  Future<void> getRecommendedJobs(String? token) async {
    if (token == null) {
      emit(GetRecommendedJobsNoToken());
      return;
    }

    emit(GetRecommendedJobsLoading());

    try {
      print('Fetching Recommended Jobs...');

      final response = await _dio.get(
        ApiEndpoints.getRecommendedJobPosts,
        options: Options(
          headers: {'Content-Type': 'application/json', 'Authorization': token},
        ),
      );

      print('Get Recommended Jobs Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        final recommendedJobsResponse = RecommendedJobPostResponse.fromJson(
          response.data,
        );

        if (recommendedJobsResponse.success) {
          emit(GetRecommendedJobsSuccess(recommendedJobsResponse.data));
        } else {
          emit(GetRecommendedJobsFailure('Failed to fetch recommended jobs'));
        }
      } else {
        emit(
          GetRecommendedJobsFailure(
            response.data['message'] ?? 'Failed to fetch recommended jobs',
          ),
        );
      }
    } on DioException catch (e) {
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error =
          e.response?.data['message'] ??
          'An error occurred while fetching recommended jobs';
      emit(GetRecommendedJobsFailure(error));
    } catch (e) {
      print('Unexpected Error: $e');
      emit(GetRecommendedJobsFailure('An unexpected error occurred: $e'));
    }
  }
}
