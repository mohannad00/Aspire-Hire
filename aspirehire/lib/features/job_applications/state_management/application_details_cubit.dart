import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/JobApplication.dart';

part 'application_details_state.dart';

class ApplicationDetailsCubit extends Cubit<ApplicationDetailsState> {
  ApplicationDetailsCubit() : super(ApplicationDetailsInitial());

  Future<void> getApplicationDetails(
    String token,
    String jobPostId,
    String applicationId,
  ) async {
    print(
      '🔵 [ApplicationDetailsCubit] Starting to fetch application details...',
    );
    print('🔵 [ApplicationDetailsCubit] Job Post ID: $jobPostId');
    print('🔵 [ApplicationDetailsCubit] Application ID: $applicationId');

    if (token.isEmpty) {
      print('❌ [ApplicationDetailsCubit] Error: token is empty');
      emit(const ApplicationDetailsFailure('Authentication token is required'));
      return;
    }

    if (jobPostId.isEmpty || applicationId.isEmpty) {
      print(
        '❌ [ApplicationDetailsCubit] Error: job post ID or application ID is empty',
      );
      emit(
        const ApplicationDetailsFailure(
          'Job post ID and application ID are required',
        ),
      );
      return;
    }

    print('🔵 [ApplicationDetailsCubit] Emitting loading state...');
    emit(ApplicationDetailsLoading());

    try {
      print('🔵 [ApplicationDetailsCubit] Creating Dio instance...');
      final dio = Dio();

      // Replace the placeholders in the endpoint with actual IDs
      final endpoint = ApiEndpoints.getJobApplication
          .replaceAll(':jobPostId', jobPostId)
          .replaceAll(':applicationId', applicationId);

      print('🔵 [ApplicationDetailsCubit] Making GET request to: $endpoint');
      final response = await dio.get(
        endpoint,
        options: Options(
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print('🔵 [ApplicationDetailsCubit] Response received!');
      print('🔵 [ApplicationDetailsCubit] Status code: ${response.statusCode}');
      print('🔵 [ApplicationDetailsCubit] Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ [ApplicationDetailsCubit] Success! Status code 200');

        // Check if the response indicates success
        if (response.data['success'] == true) {
          print(
            '✅ [ApplicationDetailsCubit] Application details retrieved successfully',
          );

          try {
            final applicationData = response.data['data'];
            final application = JobApplication.fromJson(applicationData);

            print(
              '✅ [ApplicationDetailsCubit] Application parsed successfully',
            );
            print('✅ [ApplicationDetailsCubit] Emitting success state...');
            emit(ApplicationDetailsSuccess(application));
          } catch (parseError) {
            print(
              '❌ [ApplicationDetailsCubit] Error parsing application: $parseError',
            );
            print(
              '❌ [ApplicationDetailsCubit] Application data: ${response.data['data']}',
            );
            emit(
              const ApplicationDetailsFailure(
                'Failed to parse application data',
              ),
            );
          }
        } else {
          print('❌ [ApplicationDetailsCubit] Backend returned success: false');
          print(
            '❌ [ApplicationDetailsCubit] Error message: ${response.data['message']}',
          );
          emit(
            ApplicationDetailsFailure(
              response.data['message'] ?? 'Failed to load application details',
            ),
          );
        }
      } else {
        print(
          '❌ [ApplicationDetailsCubit] Error: Unexpected status code ${response.statusCode}',
        );
        print('❌ [ApplicationDetailsCubit] Response data: ${response.data}');
        emit(
          ApplicationDetailsFailure(
            'Failed to load application details. Status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      print('❌ [ApplicationDetailsCubit] Exception caught: $e');
      print('❌ [ApplicationDetailsCubit] Exception type: ${e.runtimeType}');

      if (e is DioException) {
        print('❌ [ApplicationDetailsCubit] DioException details:');
        print('❌ [ApplicationDetailsCubit] - Type: ${e.type}');
        print('❌ [ApplicationDetailsCubit] - Message: ${e.message}');
        print('❌ [ApplicationDetailsCubit] - Error: ${e.error}');
        print('❌ [ApplicationDetailsCubit] - Response: ${e.response}');

        if (e.response != null) {
          print(
            '❌ [ApplicationDetailsCubit] - Response status: ${e.response!.statusCode}',
          );
          print(
            '❌ [ApplicationDetailsCubit] - Response data: ${e.response!.data}',
          );
        }
      }

      emit(ApplicationDetailsFailure('Network error: $e'));
    }
  }

  Future<void> updateApplicationStatus(
    String token,
    String jobPostId,
    String applicationId,
    bool isAccept,
  ) async {
    print(
      '🔵 [ApplicationDetailsCubit] Starting to update application status...',
    );
    print('🔵 [ApplicationDetailsCubit] Job Post ID: $jobPostId');
    print('🔵 [ApplicationDetailsCubit] Application ID: $applicationId');
    print(
      '🔵 [ApplicationDetailsCubit] Action: ${isAccept ? 'Accept' : 'Decline'}',
    );

    if (token.isEmpty) {
      print('❌ [ApplicationDetailsCubit] Error: token is empty');
      emit(
        const ApplicationDetailsActionFailure(
          'Authentication token is required',
        ),
      );
      return;
    }

    if (jobPostId.isEmpty || applicationId.isEmpty) {
      print(
        '❌ [ApplicationDetailsCubit] Error: job post ID or application ID is empty',
      );
      emit(
        const ApplicationDetailsActionFailure(
          'Job post ID and application ID are required',
        ),
      );
      return;
    }

    print('🔵 [ApplicationDetailsCubit] Emitting action loading state...');
    emit(ApplicationDetailsActionLoading());

    // Declare variables outside try block so they're accessible in catch block
    late final dio = Dio();
    late final endpoint = ApiEndpoints.updateJobApplication
        .replaceAll(':jobPostId', jobPostId)
        .replaceAll(':applicationId', applicationId);
    late final requestData = {'respond': isAccept};

    try {
      print('🔵 [ApplicationDetailsCubit] Creating Dio instance...');

      print('🔵 [ApplicationDetailsCubit] Making POST request to: $endpoint');
      print(
        '🔵 [ApplicationDetailsCubit] Request data: {"respond": $isAccept}',
      );

      final response = await dio.post(
        endpoint,
        data: requestData,
        options: Options(
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print('🔵 [ApplicationDetailsCubit] Response received!');
      print('🔵 [ApplicationDetailsCubit] Status code: ${response.statusCode}');
      print('🔵 [ApplicationDetailsCubit] Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ [ApplicationDetailsCubit] Success! Status code 200');

        // Check if the response indicates success
        if (response.data['success'] == true) {
          final action = isAccept ? 'accepted' : 'declined';
          final message = 'Application ${action} successfully';

          print('✅ [ApplicationDetailsCubit] Application $action successfully');
          print('✅ [ApplicationDetailsCubit] Emitting action success state...');
          emit(ApplicationDetailsActionSuccess(message));
        } else {
          print('❌ [ApplicationDetailsCubit] Backend returned success: false');
          print(
            '❌ [ApplicationDetailsCubit] Error message: ${response.data['message']}',
          );
          emit(
            ApplicationDetailsActionFailure(
              response.data['message'] ?? 'Failed to update application status',
            ),
          );
        }
      } else {
        print(
          '❌ [ApplicationDetailsCubit] Error: Unexpected status code ${response.statusCode}',
        );
        print('❌ [ApplicationDetailsCubit] Response data: ${response.data}');
        emit(
          ApplicationDetailsActionFailure(
            'Failed to update application status. Status: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      print('❌ [ApplicationDetailsCubit] DioException caught: $e');
      print('❌ [ApplicationDetailsCubit] DioException type: ${e.type}');
      print('❌ [ApplicationDetailsCubit] DioException message: ${e.message}');

      // Try alternative approaches if the first one fails
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        print('🔵 [ApplicationDetailsCubit] Trying without Bearer prefix...');
        try {
          final response = await dio.post(
            endpoint,
            data: requestData,
            options: Options(
              headers: {
                'Authorization': token,
                'Content-Type': 'application/json',
              },
              sendTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

          if (response.statusCode == 200 && response.data['success'] == true) {
            final action = isAccept ? 'accepted' : 'declined';
            final message = 'Application ${action} successfully';
            emit(ApplicationDetailsActionSuccess(message));
            return;
          }
        } catch (retryError) {
          print('❌ [ApplicationDetailsCubit] Retry also failed: $retryError');
        }
      }

      // Try with different field names
      if (e.response?.statusCode == 400) {
        print(
          '🔵 [ApplicationDetailsCubit] Trying with different field names...',
        );
        try {
          final alternativeData = {'status': isAccept};
          final response = await dio.post(
            endpoint,
            data: alternativeData,
            options: Options(
              headers: {
                'Authorization': token,
                'Content-Type': 'application/json',
              },
              sendTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

          if (response.statusCode == 200 && response.data['success'] == true) {
            final action = isAccept ? 'accepted' : 'declined';
            final message = 'Application ${action} successfully';
            emit(ApplicationDetailsActionSuccess(message));
            return;
          }
        } catch (retryError) {
          print(
            '❌ [ApplicationDetailsCubit] Alternative field name also failed: $retryError',
          );
        }
      }

      if (e.response != null) {
        print(
          '❌ [ApplicationDetailsCubit] - Response status: ${e.response!.statusCode}',
        );
        print(
          '❌ [ApplicationDetailsCubit] - Response data: ${e.response!.data}',
        );

        final errorMessage =
            e.response!.data['message'] ?? 'Network error occurred';
        emit(ApplicationDetailsActionFailure(errorMessage));
      } else {
        emit(ApplicationDetailsActionFailure('Network error: ${e.message}'));
      }
    } catch (e) {
      print('❌ [ApplicationDetailsCubit] Exception caught: $e');
      print('❌ [ApplicationDetailsCubit] Exception type: ${e.runtimeType}');
      emit(ApplicationDetailsActionFailure('Network error: $e'));
    }
  }
}
