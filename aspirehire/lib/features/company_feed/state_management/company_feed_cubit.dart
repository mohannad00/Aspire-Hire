import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Feed.dart';
import 'company_feed_states.dart';

class CompanyFeedCubit extends Cubit<CompanyFeedState> {
  CompanyFeedCubit() : super(CompanyFeedInitial());

  final Dio _dio = Dio();

  Future<void> getFeed(String token) async {
    emit(CompanyFeedLoading());
    try {
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
      if (response.statusCode == 200) {
        final feedResponse = FeedResponse.fromJson(response.data);
        emit(CompanyFeedLoaded(feedResponse));
      } else {
        final message =
            response.statusCode == 500 ? 'Server error' : 'Failed to load feed';
        emit(CompanyFeedError(message));
      }
    } catch (e) {
      final message =
          e is DioException && e.response?.statusCode == 500
              ? 'Server error'
              : 'Error fetching feed: $e';
      emit(CompanyFeedError(message));
    }
  }
}
