import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import '../../../../core/models/CompanyRegistration.dart';
import 'company_register_state.dart';

class CompanyRegisterCubit extends Cubit<CompanyRegisterState> {
  CompanyRegisterCubit() : super(CompanyRegisterInitial());

  final Dio _dio = Dio();

  Future<void> registerCompany(CompanyRegistrationRequest request) async {
    emit(CompanyRegisterLoading());

    try {
      // Print the request being sent
      print('Sending Company Registration Request: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.companyRegister,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Print the full response for debugging
      print('Company Registration Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(CompanyRegisterSuccess('Company registered successfully'));
      } else {
        emit(CompanyRegisterFailure(response.data['message'] ?? 'Registration failed'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(CompanyRegisterFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(CompanyRegisterFailure('An unexpected error occurred: $e'));
    }
  }
}