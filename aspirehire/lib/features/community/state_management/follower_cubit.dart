import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Follower.dart';
import '../../../core/models/Friend.dart';
import 'follower_state.dart';

class FollowerCubit extends Cubit<FollowerState> {
  final Dio _dio = Dio();

  FollowerCubit() : super(FollowerInitial());

  // Follow or Unfollow User
  Future<void> followOrUnfollowUser(String token, String userId) async {
    emit(FollowerLoading());
    try {
      final request = FollowRequest();
      final response = await _dio.post(
        ApiEndpoints.followOrUnfollowUser.replaceAll(':userId', userId),
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );
      final result = FollowResponse.fromJson(response.data);
      emit(FollowerActionSuccess(result.message));
    } on DioException catch (e) {
      emit(FollowerError(e.message ?? 'An error occurred'));
    }
  }

  // Get All Followers
  Future<void> getAllFollowers(String token) async {
    emit(FollowerLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllFollowers,
        options: Options(headers: {'Authorization': token}),
      );
      final followers = (response.data['data']['followers'] as List<dynamic>)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(FollowersLoaded(followers));
    } on DioException catch (e) {
      emit(FollowerError(e.message ?? 'An error occurred'));
    }
  }

  // Get All Following
  Future<void> getAllFollowing(String token) async {
    emit(FollowerLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllFollowing,
        options: Options(headers: {'Authorization': token}),
      );
      final following = (response.data['data']['following'] as List<dynamic>)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(FollowingLoaded(following));
    } on DioException catch (e) {
      emit(FollowerError(e.message ?? 'An error occurred'));
    }
  }
}