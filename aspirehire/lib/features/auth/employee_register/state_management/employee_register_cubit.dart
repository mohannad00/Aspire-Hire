import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import '../../../../core/models/employeeRegistration.dart';
import 'employee_register_state.dart';

class EmployeeRegisterCubit extends Cubit<EmployeeRegisterState> {
  EmployeeRegisterCubit() : super(EmployeeRegisterInitial());

  final Dio _dio = Dio();

  Future<void> registerEmployee(EmployeeRegistrationRequest request) async {
    emit(EmployeeRegisterLoading());

    try {
      // Print the request being sent
      print('Sending Employee Registration Request: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.employeeRegister,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Print the full response for debugging
      print('Employee Registration Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(EmployeeRegisterSuccess('Employee registered successfully'));
      } else {
        emit(EmployeeRegisterFailure(response.data['message'] ?? 'Registration failed'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(EmployeeRegisterFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(EmployeeRegisterFailure('An unexpected error occurred: $e'));
    }
  }
}