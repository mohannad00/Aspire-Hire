import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Post.dart';
import 'feed_states.dart';

class FeedCubit extends Cubit<FeedState> {
  final Dio _dio;

  FeedCubit({Dio? dio}) : _dio = dio ?? Dio(), super(const FeedInitial());

  Future<void> fetchFeedPosts(String token) async {
    emit(const FeedLoading());

    try {
      final response = await _dio.get(
        ApiEndpoints.getFeedPosts,
        options: Options(
          headers: {'Authorization': token},
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        final feedResponse = FeedResponse.fromJson(jsonData);

        if (feedResponse.success) {
          emit(FeedLoaded(feedResponse: feedResponse));
        } else {
          emit(const FeedError(message: 'Failed to load feed posts'));
        }
      } else {
        emit(FeedError(message: 'HTTP Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.response != null) {
        errorMessage = 'HTTP Error: ${e.response?.statusCode} - ${e.response?.data}';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Network timeout error';
      } else {
        errorMessage = 'Network error: ${e.message}';
      }
      emit(FeedError(message: errorMessage));
    } catch (e) {
      emit(FeedError(message: 'Unexpected error: $e'));
    }
  }
}