import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Follower.dart';
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
      if (e.response?.statusCode == 404) {
        emit(FollowerActionSuccess('User not found'));
      } else {
        emit(FollowerError(e.message ?? 'An error occurred'));
      }
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
      List<dynamic> followersList = response.data as List;
      final followers =
          followersList
              .map(
                (item) => FollowerUser.fromJson(item as Map<String, dynamic>),
              )
              .toList();
      emit(FollowersLoaded(followers));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Return empty list for 404
        emit(FollowersLoaded([]));
      } else {
        emit(FollowerError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(FollowerError('Failed to parse followers: $e'));
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
      List<dynamic> followingList = response.data as List;
      final following =
          followingList
              .map(
                (item) => FollowerUser.fromJson(item as Map<String, dynamic>),
              )
              .toList();
      emit(FollowingLoaded(following));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Return empty list for 404
        emit(FollowingLoaded([]));
      } else {
        emit(FollowerError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(FollowerError('Failed to parse following: $e'));
    }
  }
}
