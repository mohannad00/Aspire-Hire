import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/ResendConfirmation.dart';
import 'resend_confirm_state.dart';

class ResendConfirmCubit extends Cubit<ResendConfirmState> {
  ResendConfirmCubit() : super(ResendConfirmInitial());

  final Dio _dio = Dio();

  Future<void> resendConfirmation(String email) async {
    emit(ResendConfirmLoading());

    try {
      // Create the request object
      final request = ResendConfirmRequest(email: email);

      // Print the request being sent
      print('Sending Resend Confirmation Request: ${request.toJson()}');

      // Send the request
      final response = await _dio.post(
        ApiEndpoints.resendConfirm,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Print the full response for debugging
      print('Resend Confirmation Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      // Parse the response
      final resendConfirmResponse = ResendConfirmResponse.fromJson(response.data);

      if (response.statusCode == 200) {
        emit(ResendConfirmSuccess(resendConfirmResponse.message));
      } else {
        emit(ResendConfirmFailure(resendConfirmResponse.message));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(ResendConfirmFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(ResendConfirmFailure('An unexpected error occurred: $e'));
    }
  }
}