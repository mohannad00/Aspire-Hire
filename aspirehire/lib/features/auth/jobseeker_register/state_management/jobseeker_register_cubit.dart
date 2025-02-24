import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import '../../../../core/models/JobseekerRegistration.dart';
import 'jobseeker_register_state.dart';

class JobSeekerRegisterCubit extends Cubit<JobSeekerRegisterState> {
  JobSeekerRegisterCubit() : super(JobSeekerRegisterInitial());

  final Dio _dio = Dio();

  // Store the registration data
  JobSeekerRegistrationRequest _registrationData = JobSeekerRegistrationRequest();

  // Getter for registration data
  JobSeekerRegistrationRequest get registrationData => _registrationData;

  // Methods to update registration data
  void updateFirstName(String firstName) {
    _registrationData.firstName = firstName;
  }

  void updateLastName(String lastName) {
    _registrationData.lastName = lastName;
  }

  void updateEmail(String email) {
    _registrationData.email = email;
  }

  void updatePhone(String phone) {
    _registrationData.phone = phone;
  }

  void updateUsername(String username) {
    _registrationData.username = username;
  }

  void updatePassword(String password) {
    _registrationData.password = password;
  }

  // Clear registration data
  void clearRegistrationData() {
    _registrationData = JobSeekerRegistrationRequest();
  }

  Future<void> registerJobSeeker() async {
    emit(JobSeekerRegisterLoading());

    try {
      // Print the request being sent
      print('Sending Job Seeker Registration Request: ${_registrationData.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.jobseekerRegister,
        data: _registrationData.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Print the full response for debugging
      print('Job Seeker Registration Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(JobSeekerRegisterSuccess('Job Seeker registered successfully'));
        clearRegistrationData(); // Clear data after successful registration
      } else {
        emit(JobSeekerRegisterFailure(response.data['message'] ?? 'Registration failed'));
      }
    } on DioException catch (e) {
      // Print DioException details
      print('DioException: $e');
      print('DioException Type: ${e.type}');
      print('DioException Message: ${e.message}');
      print('DioException Response: ${e.response}');

      final error = e.response?.data['message'] ?? 'An error occurred';
      emit(JobSeekerRegisterFailure(error));
    } catch (e) {
      // Print unexpected errors
      print('Unexpected Error: $e');
      emit(JobSeekerRegisterFailure('An unexpected error occurred: $e'));
    }
  }
}