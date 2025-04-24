import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Feed.dart';
import 'feed_states.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedInitial());

  final Dio _dio = Dio();

  Future<void> getFeed(String token) async {
    emit(FeedLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getFeedPosts,
        options: Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final feedResponse = FeedResponse.fromJson(response.data);
        emit(FeedLoaded(feedResponse));
      } else {
        final message = response.statusCode == 500
            ? 'Server error'
            : 'Failed to load feed';
        emit(FeedError(message));
      }
    } catch (e) {
      final message = e is DioException && e.response?.statusCode == 500
          ? 'Server error'
          : 'Error fetching feed';
      emit(FeedError(message));
    }
  }
}