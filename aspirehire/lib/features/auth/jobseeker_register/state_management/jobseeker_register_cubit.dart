import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../config/database/api/end_points.dart';
import '../../../../core/models/JobseekerRegistration.dart';
import 'jobseeker_register_state.dart';

class JobSeekerRegisterCubit extends Cubit<JobSeekerRegisterState> {
  JobSeekerRegisterCubit() : super(JobSeekerRegisterInitial());

  final Dio _dio = Dio();

  Future<void> registerJobSeeker(JobseekerRegistrationRequest request) async {
    emit(JobSeekerRegisterLoading());

    try {
      // Print the request being sent
      print('Sending Job Seeker Registration Request: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.jobseekerRegister,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Print the full response for debugging
      print('Job Seeker Registration Response: $response');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        emit(JobSeekerRegisterSuccess('Job Seeker registered successfully'));
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