import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/database/api/end_points.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final Dio _dio = Dio();

  Future<void> getProfile(String token) async {
    emit(ProfileLoading());

    try {
      // Print the token being used
      print('Fetching Profile with Token: $token');

      final response = await _dio.get(
        ApiEndpoints.getEmployeeProfile,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Print the full response for debugging
      print('Profile Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(ProfileSuccess(response.data));
      } else {
        emit(ProfileFailure(response.data['message'] ?? 'Failed to fetch profile'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(ProfileFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(ProfileFailure('An unexpected error occurred: $e'));
    }
  }
}