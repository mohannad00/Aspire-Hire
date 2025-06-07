import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      final response = await _dio.put(
        ApiEndpoints.updateProfile,
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );
      final profile = Profile.fromJson(
        response.data['data'],
      ); // Extract data from response
      emit(ProfileUpdated(profile));
    } on DioException catch (e) {
      emit(ProfileError(e.message ?? 'An error occurred'));
    }
  }

  // Update Profile Picture
  Future<void> updateProfilePicture(String token, String filePath) async {
    emit(ProfileLoading());
    try {
      final formData = FormData.fromMap({
        'attachment': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.patch(
        ApiEndpoints.updateProfilePicture,
        data: formData,
        options: Options(headers: {'Authorization': token}),
      );
      final profile = Profile.fromJson(
        response.data['data'],
      ); // Extract data from response
      emit(ProfilePictureUpdated(profile));
    } on DioException catch (e) {
      emit(ProfileError(e.message ?? 'An error occurred'));
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
