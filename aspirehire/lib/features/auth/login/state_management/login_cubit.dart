import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import '../../../../core/models/Login.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final Dio _dio = Dio();
  
Future<void> login(String username, String password) async {
  emit(LoginLoading());

  try {
    // Create the LoginRequest object
    final loginRequest = LoginRequest(username: username, password: password);

    // Send the request using Dio
    final response = await _dio.post(
      ApiEndpoints.login, // Use the login endpoint from ApiEndpoints
      data: loginRequest.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Print the full response for debugging
    print('Full Response: $response');
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Data: ${response.data}');

    // Parse the response into a LoginResponse object
    final loginResponse = LoginResponse.fromJson(response.data);

    if (response.statusCode == 200) {
      emit(LoginSuccess(loginResponse.token));
    } else {
      emit(LoginFailure(loginResponse.message));
    }
  } on DioException catch (e) {

    // Print DioException details
    print('DioException: $e');
    print('DioException Type: ${e.type}');
    print('DioException Message: ${e.message}');
    print('DioException Response: ${e.response}');

    String errorMessage = 'An error occurred';

    if (e.response != null) {
      // Check if the response contains a 'message' field
      if (e.response!.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? 'An error occurred';
      } else {
        errorMessage = 'Invalid response format';
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Receive timeout';
    } else if (e.type == DioExceptionType.sendTimeout) {
      errorMessage = 'Send timeout';
    } else if (e.type == DioExceptionType.badResponse) {
      errorMessage = 'Bad response from server';
    } else if (e.type == DioExceptionType.cancel) {
      errorMessage = 'Request canceled';
    } else if (e.type == DioExceptionType.unknown) {
      errorMessage = 'Unknown error: ${e.message}';
    }

    emit(LoginFailure(errorMessage));
  } catch (e) {
    // Print unexpected errors
    print('Unexpected Error: $e');
    emit(LoginFailure('An unexpected error occurred: $e'));
  }
}
}