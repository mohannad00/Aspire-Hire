import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/CreateJobPost.dart';

part 'company_job_posts_state.dart';

class CompanyJobPostsCubit extends Cubit<CompanyJobPostsState> {
  CompanyJobPostsCubit() : super(CompanyJobPostsInitial());

  Future<void> getCompanyJobPosts(String token) async {
    print('🔵 [CompanyJobPostsCubit] Starting to fetch company job posts...');
    print('🔵 [CompanyJobPostsCubit] Token: ${token.substring(0, 20)}...');

    if (token.isEmpty) {
      print('❌ [CompanyJobPostsCubit] Error: token is empty');
      emit(CompanyJobPostsFailure('Authentication token is required'));
      return;
    }

    print('🔵 [CompanyJobPostsCubit] Emitting loading state...');
    emit(CompanyJobPostsLoading());

    try {
      print('🔵 [CompanyJobPostsCubit] Creating Dio instance...');
      final dio = Dio();

      print(
        '🔵 [CompanyJobPostsCubit] Making GET request to profile endpoint...',
      );
      final response = await dio.get(
        ApiEndpoints.getProfile,
        options: Options(
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print('🔵 [CompanyJobPostsCubit] Response received!');
      print('🔵 [CompanyJobPostsCubit] Status code: ${response.statusCode}');
      print('🔵 [CompanyJobPostsCubit] Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ [CompanyJobPostsCubit] Success! Status code 200');

        // Check if the response indicates success
        if (response.data['success'] == true) {
          print('✅ [CompanyJobPostsCubit] Profile data retrieved successfully');

          // Extract job posts from the profile data
          final profileData = response.data['data'];
          List<JobPostData> jobPosts = [];

          print('🔵 [CompanyJobPostsCubit] Profile data structure:');
          print(
            '🔵 [CompanyJobPostsCubit] - profileData: ${profileData != null ? 'exists' : 'null'}',
          );
          print(
            '🔵 [CompanyJobPostsCubit] - profileData.user: ${profileData?['user'] != null ? 'exists' : 'null'}',
          );
          print(
            '🔵 [CompanyJobPostsCubit] - profileData.user.jobPosts: ${profileData?['user']?['jobPosts'] != null ? 'exists' : 'null'}',
          );

          if (profileData != null &&
              profileData['user'] != null &&
              profileData['user']['jobPosts'] != null) {
            final jobPostsList = profileData['user']['jobPosts'] as List;
            print(
              '🔵 [CompanyJobPostsCubit] Job posts list length: ${jobPostsList.length}',
            );

            try {
              jobPosts =
                  jobPostsList.map((jobPostJson) {
                    try {
                      return JobPostData.fromJson(jobPostJson);
                    } catch (parseError) {
                      print(
                        '❌ [CompanyJobPostsCubit] Error parsing job post: $parseError',
                      );
                      print(
                        '❌ [CompanyJobPostsCubit] Job post data: $jobPostJson',
                      );
                      // Return a default job post or skip this one
                      return JobPostData(
                        jobTitle: 'Error Loading Job',
                        jobCategory: '',
                        jobDescription: '',
                        requiredSkills: [],
                        location: '',
                        country: '',
                        city: '',
                        salary: 0,
                        jobPeriod: '',
                        experience: '',
                        applicationDeadline: DateTime.now(),
                        jobType: '',
                        archived: false,
                        id: 'error-${DateTime.now().millisecondsSinceEpoch}',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                    }
                  }).toList();
            } catch (listError) {
              print(
                '❌ [CompanyJobPostsCubit] Error processing job posts list: $listError',
              );
              jobPosts = [];
            }
          } else {
            print(
              '🔵 [CompanyJobPostsCubit] No job posts found in response structure',
            );
          }

          print('✅ [CompanyJobPostsCubit] Found ${jobPosts.length} job posts');
          print('✅ [CompanyJobPostsCubit] Emitting success state...');
          emit(CompanyJobPostsSuccess(jobPosts));
        } else {
          print('❌ [CompanyJobPostsCubit] Backend returned success: false');
          print(
            '❌ [CompanyJobPostsCubit] Error message: ${response.data['message']}',
          );
          emit(
            CompanyJobPostsFailure(
              response.data['message'] ?? 'Failed to load job posts',
            ),
          );
        }
      } else {
        print(
          '❌ [CompanyJobPostsCubit] Error: Unexpected status code ${response.statusCode}',
        );
        print('❌ [CompanyJobPostsCubit] Response data: ${response.data}');
        emit(
          CompanyJobPostsFailure(
            'Failed to load job posts. Status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      print('❌ [CompanyJobPostsCubit] Exception caught: $e');
      print('❌ [CompanyJobPostsCubit] Exception type: ${e.runtimeType}');

      if (e is DioException) {
        print('❌ [CompanyJobPostsCubit] DioException details:');
        print('❌ [CompanyJobPostsCubit] - Type: ${e.type}');
        print('❌ [CompanyJobPostsCubit] - Message: ${e.message}');
        print('❌ [CompanyJobPostsCubit] - Error: ${e.error}');
        print('❌ [CompanyJobPostsCubit] - Response: ${e.response}');

        if (e.response != null) {
          print(
            '❌ [CompanyJobPostsCubit] - Response status: ${e.response!.statusCode}',
          );
          print(
            '❌ [CompanyJobPostsCubit] - Response data: ${e.response!.data}',
          );
        }
      }

      emit(CompanyJobPostsFailure('Network error: $e'));
    }
  }
}
