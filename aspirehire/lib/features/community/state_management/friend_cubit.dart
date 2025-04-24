import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Friend.dart';
import 'friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  final Dio _dio = Dio();

  FriendCubit() : super(FriendInitial()) {
    print('FriendCubit initialized');
  }

  Future<void> sendOrCancelFriendRequest(String token, String userId) async {
    print('[sendOrCancelFriendRequest] Starting with userId: $userId');
    emit(FriendLoading());
    try {
      final url = ApiEndpoints.sendOrCancelFriendRequest.replaceAll(
        ':userId',
        userId,
      );
      print('[sendOrCancelFriendRequest] Calling endpoint: $url');

      final response = await _dio.post(
        url,
        options: Options(headers: {'Authorization': token}),
      );

      print('[sendOrCancelFriendRequest] Response: ${response.data}');
      final message = response.data['message'] ?? 'Request sent';
      print('[sendOrCancelFriendRequest] Success: $message');
      emit(FriendRequestSent(message));
    } on DioException catch (e) {
      print('[sendOrCancelFriendRequest] Error: ${e.message}');
      print('[sendOrCancelFriendRequest] Error details: ${e.response?.data}');
      emit(FriendError(e.message ?? 'Failed to send request'));
    } catch (e) {
      print('[sendOrCancelFriendRequest] Unexpected error: $e');
      emit(FriendError('An unexpected error occurred'));
    }
  }

  Future<void> approveOrDeclineFriendRequest(
    String token,
    String userId,
    bool action,
  ) async {
    print(
      '[approveOrDeclineFriendRequest] Starting with userId: $userId, action: $action',
    );
    emit(FriendLoading());
    try {
      final url = ApiEndpoints.approveOrDeclineFriendRequest.replaceAll(
        ':userId',
        userId,
      );
      print('[approveOrDeclineFriendRequest] Calling endpoint: $url');

      final response = await _dio.patch(
        url,
        data: {'action': action},
        options: Options(headers: {'Authorization': token}),
      );

      print('[approveOrDeclineFriendRequest] Response: ${response.data}');
      final message = response.data['message'] ?? 'Request updated';
      print('[approveOrDeclineFriendRequest] Success: $message');
      emit(FriendRequestApproved(message));
    } on DioException catch (e) {
      print('[approveOrDeclineFriendRequest] Error: ${e.message}');
      print(
        '[approveOrDeclineFriendRequest] Error details: ${e.response?.data}',
      );
      emit(FriendError(e.message ?? 'Failed to update request'));
    } catch (e) {
      print('[approveOrDeclineFriendRequest] Unexpected error: $e');
      emit(FriendError('An unexpected error occurred'));
    }
  }

  Future<void> unfriendUser(String token, String userId) async {
    print('[unfriendUser] Starting with userId: $userId');
    emit(FriendLoading());
    try {
      final url = ApiEndpoints.unfriendUser.replaceAll(':userId', userId);
      print('[unfriendUser] Calling endpoint: $url');

      final response = await _dio.post(
        url,
        options: Options(headers: {'Authorization': token}),
      );

      print('[unfriendUser] Response: ${response.data}');
      final message = response.data['message'] ?? 'Unfriended successfully';
      print('[unfriendUser] Success: $message');
      emit(FriendUnfriended(message));
    } on DioException catch (e) {
      print('[unfriendUser] Error: ${e.message}');
      print('[unfriendUser] Error details: ${e.response?.data}');
      emit(FriendError(e.message ?? 'Failed to unfriend'));
    } catch (e) {
      print('[unfriendUser] Unexpected error: $e');
      emit(FriendError('An unexpected error occurred'));
    }
  }

  Future<void> getAllFriends(String token) async {
    print('[getAllFriends] Starting');
    emit(FriendLoading());
    try {
      print('[getAllFriends] Calling endpoint: ${ApiEndpoints.getAllFriends}');

      final response = await _dio.get(
        ApiEndpoints.getAllFriends,
        options: Options(headers: {'Authorization': token}),
      );

      print('[getAllFriends] Full response: ${response.data}');
      final friendsList = response.data['data']['friends'] as List;
      print('[getAllFriends] Found ${friendsList.length} friends');

      final friends =
          friendsList
              .map((item) => User.fromJson(item as Map<String, dynamic>))
              .toList();

      print(
        '[getAllFriends] First friend: ${friends.isNotEmpty ? friends.first.toJson() : "None"}',
      );
      emit(FriendsLoaded(friends));
    } on DioException catch (e) {
      print('[getAllFriends] Error: ${e.message}');
      print('[getAllFriends] Error details: ${e.response?.data}');
      emit(FriendError(e.message ?? 'Failed to load friends'));
    } catch (e) {
      print('[getAllFriends] Unexpected error: $e');
      emit(FriendError('An unexpected error occurred'));
    }
  }

  Future<void> getAllFriendRequests(String token) async {
    print('[getAllFriendRequests] Starting');
    emit(FriendLoading());
    try {
      print(
        '[getAllFriendRequests] Calling endpoint: ${ApiEndpoints.getAllFriendRequests}',
      );

      final response = await _dio.get(
        ApiEndpoints.getAllFriendRequests,
        options: Options(headers: {'Authorization': token}),
      );

      print('[getAllFriendRequests] Full response: ${response.data}');

      if (response.data['success'] == true && response.data['data'] is List) {
        final requestsList = response.data['data'] as List;
        print('[getAllFriendRequests] Found ${requestsList.length} requests');

        final requests =
            requestsList
                .map(
                  (item) =>
                      FriendRequest.fromJson(item as Map<String, dynamic>),
                )
                .toList();

        print(
          '[getAllFriendRequests] First request: ${requests.isNotEmpty ? requests.first.toJson() : "None"}',
        );
        emit(FriendRequestsLoaded(requests));
      } else {
        print('[getAllFriendRequests] Invalid response format');
        emit(FriendError('Invalid response format'));
      }
    } on DioException catch (e) {
      print('[getAllFriendRequests] Error: ${e.message}');
      print('[getAllFriendRequests] Error details: ${e.response?.data}');
      emit(FriendError(e.message ?? 'Failed to load requests'));
    } catch (e) {
      print('[getAllFriendRequests] Unexpected error: $e');
      emit(FriendError('An unexpected error occurred'));
    }
  }
}
