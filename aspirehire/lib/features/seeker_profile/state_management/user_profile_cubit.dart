import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/UserProfile.dart';
import '../../../core/models/Feed.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final Dio _dio = Dio();

  // Cache for profile data
  static final Map<String, UserProfileData> _profileCache = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  UserProfileCubit() : super(UserProfileInitial());

  Future<void> getUserProfile(String token, String userId) async {
    emit(UserProfileLoading());

    try {
      // Check cache first
      final cacheKey = '${userId}_$token';
      final cachedData = _profileCache[cacheKey];
      if (cachedData != null) {
        emit(UserProfileLoaded(cachedData));
        return;
      }

      final url = ApiEndpoints.getProfileByUserId.replaceAll(':userId', userId);
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': token},
          // Add timeout to prevent hanging requests
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.data['success'] == true) {
        final userProfileResponse = UserProfileResponse.fromJson(response.data);

        // Use the posts data directly from the profile response
        // This eliminates the need for individual post fetching
        final userProfileData = UserProfileData(
          user: userProfileResponse.data.user,
          posts: userProfileResponse.data.posts,
        );

        // Cache the result
        _profileCache[cacheKey] = userProfileData;

        // Clear old cache entries periodically
        _cleanupCache();

        emit(UserProfileLoaded(userProfileData));
      } else {
        emit(
          UserProfileError(
            response.data['message'] ?? 'Failed to load profile',
          ),
        );
      }
    } on DioException catch (e) {
      print('DioException in getUserProfile: ${e.message}');
      print('Response: ${e.response?.data}');

      String errorMessage = 'An error occurred';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(UserProfileError(errorMessage));
    } catch (e) {
      print('Unexpected error in getUserProfile: $e');
      emit(UserProfileError('Unexpected error: $e'));
    }
  }

  // Method to fetch full post data when needed (for posts tab)
  Future<Post?> getFullPostData(String token, String postId) async {
    try {
      final postUrl = ApiEndpoints.getPost.replaceAll(':postId', postId);
      final response = await _dio.get(
        postUrl,
        options: Options(
          headers: {'Authorization': token},
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.data['success'] == true) {
        return Post.fromJson(response.data['data']);
      }
    } catch (e) {
      print('Error fetching full post data: $e');
    }
    return null;
  }

  // Clear cache for a specific user
  void clearUserCache(String userId, String token) {
    final cacheKey = '${userId}_$token';
    _profileCache.remove(cacheKey);
  }

  // Clear all cache
  void clearAllCache() {
    _profileCache.clear();
  }

  // Cleanup old cache entries
  void _cleanupCache() {
    if (_profileCache.length > 20) {
      // Keep only 20 most recent profiles
      final keysToRemove = _profileCache.keys.take(_profileCache.length - 20);
      for (final key in keysToRemove) {
        _profileCache.remove(key);
      }
    }
  }

  @override
  Future<void> close() {
    // Cleanup when cubit is closed
    _cleanupCache();
    return super.close();
  }
}
