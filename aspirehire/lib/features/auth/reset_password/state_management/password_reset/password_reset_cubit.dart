import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../../config/database/api/end_points.dart';
import '../../../../../core/models/RequestPasswordReset.dart';
import 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit() : super(PasswordResetInitial());

  final Dio _dio = Dio();

  Future<void> resetPassword(String token, String newPassword) async {
    emit(PasswordResetLoading());

    try {
      // Create the request object
      final request = PasswordResetRequest(newPassword: newPassword);

      // Print the request being sent
      print('Sending Password Reset Request: {token: $token, request: ${request.toJson()}');

      // Send the request
      final response = await _dio.post(
        '${ApiEndpoints.passwordReset}?token=$token',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Print the full response for debugging
      print('Password Reset Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      // Parse the response
      final passwordResetResponse = PasswordResetResponse.fromJson(response.data);

      if (response.statusCode == 200) {
        emit(PasswordResetSuccess(passwordResetResponse.message));
      } else {
        emit(PasswordResetFailure(passwordResetResponse.message));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(PasswordResetFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(PasswordResetFailure('An unexpected error occurred: $e'));
    }
  }
}