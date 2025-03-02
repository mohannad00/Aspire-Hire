import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../../config/datasources/api/end_points.dart';
import '../../../../../core/models/RequestPasswordReset.dart';
import 'request_password_reset_state.dart';

class RequestPasswordResetCubit extends Cubit<RequestPasswordResetState> {
  RequestPasswordResetCubit() : super(RequestPasswordResetInitial());

  final Dio _dio = Dio();

  Future<void> requestPasswordReset(String email) async {
    emit(RequestPasswordResetLoading());

    try {
      // Create the request object
      final request = RequestPasswordResetRequest(email: email);

      // Print the request being sent
      print('Sending Request Password Reset Request: ${request.toJson()}');

      // Send the request
      final response = await _dio.post(
        ApiEndpoints.requestPasswordReset,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Print the full response for debugging
      print('Request Password Reset Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      // Parse the response
      final requestPasswordResetResponse = RequestPasswordResetResponse.fromJson(response.data);

      if (response.statusCode == 200) {
        emit(RequestPasswordResetSuccess(requestPasswordResetResponse.message));
      } else {
        emit(RequestPasswordResetFailure(requestPasswordResetResponse.message));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(RequestPasswordResetFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(RequestPasswordResetFailure('An unexpected error occurred: $e'));
    }
  }
}