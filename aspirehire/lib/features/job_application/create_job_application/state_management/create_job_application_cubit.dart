import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import '../../../../config/datasources/api/end_points.dart';
import '../../../../core/models/CreateJobApplication.dart';

part 'create_job_application_state.dart';

class CreateJobApplicationCubit extends Cubit<CreateJobApplicationState> {
  CreateJobApplicationCubit() : super(CreateJobApplicationInitial());

  Future<void> createJobApplication({
    required String jobPostId,
    required String coverLetter,
    required File attachment,
    required String token,
  }) async {
    print(
      '🔵 [CreateJobApplicationCubit] Starting job application creation...',
    );
    print('🔵 [CreateJobApplicationCubit] JobPostId: $jobPostId');
    print(
      '🔵 [CreateJobApplicationCubit] CoverLetter length: ${coverLetter.length}',
    );
    print('🔵 [CreateJobApplicationCubit] Attachment path: ${attachment.path}');
    print(
      '🔵 [CreateJobApplicationCubit] Attachment exists: ${await attachment.exists()}',
    );
    print('🔵 [CreateJobApplicationCubit] Token: ${token.substring(0, 20)}...');

    // Validate inputs
    if (jobPostId.isEmpty) {
      print('❌ [CreateJobApplicationCubit] Error: jobPostId is empty');
      emit(CreateJobApplicationFailure('Job post ID is required'));
      return;
    }

    if (coverLetter.trim().isEmpty) {
      print('❌ [CreateJobApplicationCubit] Error: coverLetter is empty');
      emit(CreateJobApplicationFailure('Cover letter is required'));
      return;
    }

    if (!await attachment.exists()) {
      print(
        '❌ [CreateJobApplicationCubit] Error: attachment file does not exist',
      );
      emit(CreateJobApplicationFailure('Resume file not found'));
      return;
    }

    if (token.isEmpty) {
      print('❌ [CreateJobApplicationCubit] Error: token is empty');
      emit(CreateJobApplicationFailure('Authentication token is required'));
      return;
    }

    print('🔵 [CreateJobApplicationCubit] Emitting loading state...');
    emit(CreateJobApplicationLoading());

    try {
      print('🔵 [CreateJobApplicationCubit] Creating Dio instance...');
      final dio = Dio();

      print('🔵 [CreateJobApplicationCubit] Preparing FormData...');

      // Get file extension and set proper MIME type
      final String filePath = attachment.path;
      final String extension = filePath.split('.').last.toLowerCase();
      final String mimeType = 'application/pdf'; // PDF MIME type

      print('🔵 [CreateJobApplicationCubit] File extension: $extension');
      print('🔵 [CreateJobApplicationCubit] MIME type: $mimeType');
      print(
        '🔵 [CreateJobApplicationCubit] Original filename: ${attachment.path.split('/').last}',
      );

      // Try different field names that the backend might expect
      final formData = FormData.fromMap({
        'coverLetter': coverLetter,
        'attachment': await MultipartFile.fromFile(
          attachment.path,
          filename: 'resume.$extension',
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      // Alternative field names to try if the first one fails
      // 'resume', 'cv', 'file', 'document'

      print('🔵 [CreateJobApplicationCubit] FormData created successfully');
      print(
        '🔵 [CreateJobApplicationCubit] FormData fields: ${formData.fields}',
      );
      print('🔵 [CreateJobApplicationCubit] FormData files: ${formData.files}');

      final endpoint = ApiEndpoints.createJobApplication.replaceFirst(
        ':jobPostId',
        jobPostId,
      );
      print('🔵 [CreateJobApplicationCubit] API Endpoint: $endpoint');
      print('🔵 [CreateJobApplicationCubit] Making POST request...');

      final response = await dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print('🔵 [CreateJobApplicationCubit] Response received!');
      print(
        '🔵 [CreateJobApplicationCubit] Status code: ${response.statusCode}',
      );
      print('🔵 [CreateJobApplicationCubit] Response data: ${response.data}');
      print(
        '🔵 [CreateJobApplicationCubit] Response headers: ${response.headers}',
      );

      if (response.statusCode == 201) {
        print('✅ [CreateJobApplicationCubit] Success! Status code 201');
        print('✅ [CreateJobApplicationCubit] Response data: ${response.data}');

        // Check if the response indicates success
        if (response.data['success'] == true) {
          print(
            '✅ [CreateJobApplicationCubit] Application submitted successfully',
          );
          print('✅ [CreateJobApplicationCubit] Emitting success state...');
          emit(CreateJobApplicationSuccess());
        } else {
          print(
            '❌ [CreateJobApplicationCubit] Backend returned success: false',
          );
          print(
            '❌ [CreateJobApplicationCubit] Error message: ${response.data['message']}',
          );
          emit(
            CreateJobApplicationFailure(
              response.data['message'] ?? 'Application submission failed',
            ),
          );
        }
      } else {
        print(
          '❌ [CreateJobApplicationCubit] Error: Unexpected status code ${response.statusCode}',
        );
        print('❌ [CreateJobApplicationCubit] Response data: ${response.data}');
        emit(
          CreateJobApplicationFailure(
            'Failed to create job application. Status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      print('❌ [CreateJobApplicationCubit] Exception caught: $e');
      print('❌ [CreateJobApplicationCubit] Exception type: ${e.runtimeType}');

      if (e is DioException) {
        print('❌ [CreateJobApplicationCubit] DioException details:');
        print('❌ [CreateJobApplicationCubit] - Type: ${e.type}');
        print('❌ [CreateJobApplicationCubit] - Message: ${e.message}');
        print('❌ [CreateJobApplicationCubit] - Error: ${e.error}');
        print('❌ [CreateJobApplicationCubit] - Response: ${e.response}');
        print(
          '❌ [CreateJobApplicationCubit] - RequestOptions: ${e.requestOptions}',
        );

        if (e.response != null) {
          print(
            '❌ [CreateJobApplicationCubit] - Response status: ${e.response!.statusCode}',
          );
          print(
            '❌ [CreateJobApplicationCubit] - Response data: ${e.response!.data}',
          );
        }
      }

      emit(CreateJobApplicationFailure('You have already applied for this job'));
    }
  }
}
