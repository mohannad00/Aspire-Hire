import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/DeleteProfilePicture.dart';
import '../../../core/models/GetProfile.dart';
import '../../../core/models/UpdateProfileRequest.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio = Dio(); // Internal Dio instance

  ProfileCubit() : super(ProfileInitial());

  // Get Profile
  Future<void> getProfile(String token) async {
    emit(ProfileLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getProfile,
        options: Options(headers: {'Authorization': token}),
      );
      print(response.data);
      final profile = Profile.fromJson(
        response.data['data']['user'],
      ); // Extract data from response
      emit(ProfileLoaded(profile));
    } on DioException catch (e) {
      emit(ProfileError(e.message ?? 'An error occurred'));
    }
  }

  // Update Profile
  Future<void> updateProfile(String token, UpdateProfileRequest request) async {
    emit(ProfileLoading());
    try {
      print('Update Profile Request: ${request.toJson()}');
      final response = await _dio.put(
        ApiEndpoints.updateProfile,
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );

      print('Update Profile Response: ${response.data}');

      if (response.data['success'] == true) {
        final profile = Profile.fromJson(
          response.data['data'],
        ); // Extract data from response
        emit(ProfileUpdated(profile));
      } else {
        emit(ProfileError(response.data['message'] ?? 'Update failed'));
      }
    } on DioException catch (e) {
      print('DioException in updateProfile: ${e.message}');
      print('Response: ${e.response?.data}');

      String errorMessage = 'An error occurred';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(ProfileError(errorMessage));
    }
  }

  // Update Profile Picture
  Future<void> updateProfilePicture(String token, String filePath) async {
    emit(ProfileLoading());
    try {
      // Check if file exists
      final file = File(filePath);
      if (!await file.exists()) {
        emit(ProfileError('Selected image file does not exist'));
        return;
      }

      // Check file size (limit to 5MB)
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        emit(
          ProfileError(
            'Image file is too large. Please select an image smaller than 5MB',
          ),
        );
        return;
      }

      print('Uploading profile picture: $filePath, size: ${fileSize} bytes');

      final formData = FormData.fromMap({
        'attachment': await MultipartFile.fromFile(filePath),
      });

      print(
        'FormData created, sending request to: ${ApiEndpoints.updateProfilePicture}',
      );
      print('Token: $token');

      final response = await _dio.patch(
        ApiEndpoints.updateProfilePicture,
        data: formData,
        options: Options(headers: {'Authorization': token}),
      );

      print('Update Profile Picture Response: ${response.data}');

      if (response.data['success'] == true) {
        final profile = Profile.fromJson(
          response.data['data'],
        ); // Extract data from response
        emit(ProfilePictureUpdated(profile));
      } else {
        emit(
          ProfileError(
            response.data['message'] ?? 'Profile picture update failed',
          ),
        );
      }
    } on DioException catch (e) {
      print('DioException in updateProfilePicture: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Request data: ${e.requestOptions.data}');
      print('Request headers: ${e.requestOptions.headers}');

      String errorMessage = 'An error occurred while updating profile picture';

      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.response?.statusCode == 400) {
        errorMessage =
            'Invalid request. Please check the image format and try again.';
      } else if (e.response?.statusCode == 413) {
        errorMessage =
            'Image file is too large. Please select a smaller image.';
      } else if (e.response?.statusCode == 401) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(ProfileError(errorMessage));
    } catch (e) {
      print('Unexpected error in updateProfilePicture: $e');
      emit(ProfileError('Unexpected error: $e'));
    }
  }

  // Upload Resume
  Future<void> uploadResume(String token, String filePath) async {
    emit(ProfileLoading());
    try {
      final formData = FormData.fromMap({
        'attachment': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.patch(
        ApiEndpoints.uploadResume,
        data: formData,
        options: Options(headers: {'Authorization': token}),
      );
      final profile = Profile.fromJson(
        response.data['data'],
      ); // Extract data from response
      emit(ResumeUploaded(profile));
    } on DioException catch (e) {
      emit(ProfileError(e.message ?? 'An error occurred'));
    }
  }

  // Update Skills
  Future<void> updateSkills(String token, List<String> skills) async {
    emit(ProfileLoading());
    try {
      final request = UpdateSkillsRequest(skills: skills);
      final response = await _dio.put(
        ApiEndpoints.updateSkills,
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );

      print('Update Skills Response: ${response.data}');

      if (response.data['success'] == true) {
        final profile = Profile.fromJson(
          response.data['data'],
        ); // Extract data from response
        emit(ProfileUpdated(profile));
      } else {
        emit(ProfileError(response.data['message'] ?? 'Skills update failed'));
      }
    } on DioException catch (e) {
      print('DioException in updateSkills: ${e.message}');
      print('Response: ${e.response?.data}');

      String errorMessage = 'An error occurred';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(ProfileError(errorMessage));
    }
  }

  // Delete Profile Picture
  Future<void> deleteProfilePicture(String token) async {
    emit(ProfileLoading());
    try {
      final response = await _dio.delete(
        ApiEndpoints.deleteProfilePicture,
        options: Options(headers: {'Authorization': token}),
      );
      final message =
          DeleteProfilePictureResponse.fromJson(response.data).message;
      emit(ProfilePictureDeleted(message));
    } on DioException catch (e) {
      emit(ProfileError(e.message ?? 'An error occurred'));
    }
  }
}
