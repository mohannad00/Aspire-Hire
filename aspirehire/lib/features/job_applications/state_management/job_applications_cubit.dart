import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/JobApplication.dart';

part 'job_applications_state.dart';

class JobApplicationsCubit extends Cubit<JobApplicationsState> {
  JobApplicationsCubit() : super(JobApplicationsInitial());

  Future<void> getJobApplications(String token, String jobPostId) async {
    print('🔵 [JobApplicationsCubit] Starting to fetch job applications...');
    print('🔵 [JobApplicationsCubit] Job Post ID: $jobPostId');

    if (token.isEmpty) {
      print('❌ [JobApplicationsCubit] Error: token is empty');
      emit(JobApplicationsFailure('Authentication token is required'));
      return;
    }

    if (jobPostId.isEmpty) {
      print('❌ [JobApplicationsCubit] Error: job post ID is empty');
      emit(JobApplicationsFailure('Job post ID is required'));
      return;
    }

    print('🔵 [JobApplicationsCubit] Emitting loading state...');
    emit(JobApplicationsLoading());

    try {
      print('🔵 [JobApplicationsCubit] Creating Dio instance...');
      final dio = Dio();

      // Replace the placeholder in the endpoint with the actual job post ID
      final endpoint = ApiEndpoints.getJobApplications.replaceAll(
        ':jobPostId',
        jobPostId,
      );

      print('🔵 [JobApplicationsCubit] Making GET request to: $endpoint');
      final response = await dio.get(
        endpoint,
        options: Options(
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print('🔵 [JobApplicationsCubit] Response received!');
      print('🔵 [JobApplicationsCubit] Status code: ${response.statusCode}');
      print('🔵 [JobApplicationsCubit] Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ [JobApplicationsCubit] Success! Status code 200');

        // Check if the response indicates success
        if (response.data['success'] == true) {
          print(
            '✅ [JobApplicationsCubit] Job applications retrieved successfully',
          );

          // Extract applications from the response data
          final applicationsData = response.data['data'];
          List<JobApplication> applications = [];

          if (applicationsData != null && applicationsData is List) {
            print(
              '🔵 [JobApplicationsCubit] Applications list length: ${applicationsData.length}',
            );

            try {
              applications =
                  applicationsData
                      .map((applicationJson) {
                        try {
                          return JobApplication.fromJson(applicationJson);
                        } catch (parseError) {
                          print(
                            '❌ [JobApplicationsCubit] Error parsing application: $parseError',
                          );
                          print(
                            '❌ [JobApplicationsCubit] Application data: $applicationJson',
                          );
                          // Skip this application if it fails to parse
                          return null;
                        }
                      })
                      .where((app) => app != null)
                      .cast<JobApplication>()
                      .toList();
            } catch (listError) {
              print(
                '❌ [JobApplicationsCubit] Error processing applications list: $listError',
              );
              applications = [];
            }
          } else {
            print(
              '🔵 [JobApplicationsCubit] No applications found in response structure',
            );
          }

          print(
            '✅ [JobApplicationsCubit] Found ${applications.length} applications',
          );
          print('✅ [JobApplicationsCubit] Emitting success state...');
          emit(JobApplicationsSuccess(applications));
        } else {
          print('❌ [JobApplicationsCubit] Backend returned success: false');
          print(
            '❌ [JobApplicationsCubit] Error message: ${response.data['message']}',
          );
          emit(
            JobApplicationsFailure(
              response.data['message'] ?? 'Failed to load job applications',
            ),
          );
        }
      } else if (response.statusCode == 404) {
        // Handle 404 as "no applications yet"
        print(
          '🔵 [JobApplicationsCubit] 404 status code detected - treating as no applications',
        );
        emit(
          JobApplicationsSuccess(const []),
        ); // Empty list means no applications
      } else {
        print(
          '❌ [JobApplicationsCubit] Error: Unexpected status code ${response.statusCode}',
        );
        print('❌ [JobApplicationsCubit] Response data: ${response.data}');
        emit(
          JobApplicationsFailure(
            'Failed to load job applications. Status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      print('❌ [JobApplicationsCubit] Exception caught: $e');
      print('❌ [JobApplicationsCubit] Exception type: ${e.runtimeType}');

      if (e is DioException) {
        print('❌ [JobApplicationsCubit] DioException details:');
        print('❌ [JobApplicationsCubit] - Type: ${e.type}');
        print('❌ [JobApplicationsCubit] - Message: ${e.message}');
        print('❌ [JobApplicationsCubit] - Error: ${e.error}');
        print('❌ [JobApplicationsCubit] - Response: ${e.response}');

        if (e.response != null) {
          print(
            '❌ [JobApplicationsCubit] - Response status: ${e.response!.statusCode}',
          );
          print(
            '❌ [JobApplicationsCubit] - Response data: ${e.response!.data}',
          );

          // Handle 404 error as "no applications yet"
          if (e.response!.statusCode == 404) {
            print(
              '🔵 [JobApplicationsCubit] 404 error detected - treating as no applications',
            );
            emit(
              JobApplicationsSuccess(const []),
            ); // Empty list means no applications
            return;
          }
        }
      }

      emit(JobApplicationsFailure('Network error: $e'));
    }
  }
}
