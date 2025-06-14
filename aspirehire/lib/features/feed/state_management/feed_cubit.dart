import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Feed.dart';
import 'feed_states.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedInitial());

  final Dio _dio = Dio();

  Future<void> getFeed(String token) async {
    print(
      '🔍 [FeedCubit] Starting getFeed with token: ${token.substring(0, 20)}...',
    );
    emit(FeedLoading());
    try {
      print('🔍 [FeedCubit] Making API call to: ${ApiEndpoints.getFeedPosts}');

      // Add query parameters that might be required
      final queryParameters = {'limit': '50', 'page': '1'};

      final response = await _dio.get(
        ApiEndpoints.getFeedPosts,
        queryParameters: queryParameters,
        options: Options(
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      print("🔍 [FeedCubit] Response Status Code: ${response.statusCode}");
      print("🔍 [FeedCubit] Response Headers: ${response.headers}");
      print("🔍 [FeedCubit] Response Data Type: ${response.data.runtimeType}");
      print("🔍 [FeedCubit] Response Data: ${response.data}");

      if (response.statusCode == 200) {
        print('🔍 [FeedCubit] Parsing response data...');
        final feedResponse = FeedResponse.fromJson(response.data);
        print(
          '🔍 [FeedCubit] Parsed successfully. Posts count: ${feedResponse.data.length}',
        );
        print('🔍 [FeedCubit] Success: ${feedResponse.success}');
        emit(FeedLoaded(feedResponse));
      } else {
        final message =
            response.statusCode == 500 ? 'Server error' : 'Failed to load feed';
        print('🔍 [FeedCubit] Error: $message');
        emit(FeedError(message));
      }
    } catch (e) {
      print('🔍 [FeedCubit] Exception caught: $e');
      if (e is DioException) {
        print('🔍 [FeedCubit] DioException Type: ${e.type}');
        print('🔍 [FeedCubit] DioException Message: ${e.message}');
        print('🔍 [FeedCubit] DioException Response: ${e.response?.data}');
        print(
          '🔍 [FeedCubit] DioException Status Code: ${e.response?.statusCode}',
        );
      }
      final message =
          e is DioException && e.response?.statusCode == 500
              ? 'Server error'
              : 'Error fetching feed: $e';
      emit(FeedError(message));
    }
  }
}
