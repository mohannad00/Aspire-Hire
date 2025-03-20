import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/datasources/api/end_points.dart';
import '../../../../core/models/CompanyRegistration.dart'; // Ensure this import points to your model file
import 'company_register_state.dart';

class CompanyRegisterCubit extends Cubit<CompanyRegisterState> {
  CompanyRegisterCubit() : super(CompanyRegisterInitial());

  final Dio _dio = Dio();

  // Store the registration data
  CompanyRegistrationRequest _registrationData = CompanyRegistrationRequest();

  // Getter for registration data
  CompanyRegistrationRequest get registrationData => _registrationData;

  // Methods to update registration data
  void updateEmail(String email) {
    _registrationData.email = email;
  }

  void updatePassword(String password) {
    _registrationData.password = password;
  }

  void updatePhone(String phone) {
    _registrationData.phone = phone;
  }

  void updateUsername(String username) {
    _registrationData.username = username;
  }

  void updateCompanyName(String companyName) {
    _registrationData.companyName = companyName;
  }

  void updateAddress(String address) {
    _registrationData.address = address;
  }

  // Clear registration data
  void clearRegistrationData() {
    _registrationData = CompanyRegistrationRequest();
  }

  Future<void> registerCompany() async {
    emit(CompanyRegisterLoading());

    try {
      // Print the request being sent
      print('Sending Company Registration Request: ${_registrationData.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.companyRegister,
        data: _registrationData.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Print the full response for debugging
      print('Company Registration Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final CompanyRegistrationResponse registrationResponse =
            CompanyRegistrationResponse.fromJson(response.data);

        emit(CompanyRegisterSuccess(registrationResponse.message));
        clearRegistrationData(); // Clear data after successful registration
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