import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/SummaryRequest.dart';
import '../../../core/models/SummaryResponse.dart';
import 'generate_summary_state.dart';

class GenerateSummaryCubit extends Cubit<GenerateSummaryState> {
  final Dio _dio = Dio();

  GenerateSummaryCubit() : super(GenerateSummaryInitial());

  Future<void> generateSummary(SummaryRequest request) async {
    emit(GenerateSummaryLoading());

    try {
      final response = await _dio.post(
        ApiEndpoints.generateSummary,
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final summaryResponse = SummaryResponse.fromJson(response.data);
        emit(GenerateSummarySuccess(summaryResponse));
      } else {
        emit(GenerateSummaryFailure('Failed to generate summary'));
      }
    } catch (e) {
      emit(GenerateSummaryFailure(e.toString()));
    }
  }

  Future<void> generateSummaryFromProfile(String token) async {
    emit(GenerateSummaryLoading());

    try {
      // First, get the user's profile
      final profileResponse = await _dio.get(
        ApiEndpoints.getProfile,
        options: Options(headers: {'Authorization': token}),
      );

      if (profileResponse.statusCode == 200 &&
          profileResponse.data['success'] == true) {
        final profileData = profileResponse.data['data'];

        // Extract skills from the profile
        List<String> skills = [];
        if (profileData['skills'] != null) {
          skills =
              (profileData['skills'] as List)
                  .map((skill) => skill['skill'] ?? '')
                  .where((skill) => skill.isNotEmpty)
                  .cast<String>()
                  .toList();
        }

        // If no skills found, provide a default
        if (skills.isEmpty) {
          skills = ['General Skills'];
        }

        // Extract education information
        String education = 'Not specified';
        if (profileData['education'] != null &&
            (profileData['education'] as List).isNotEmpty) {
          final firstEducation = profileData['education'][0];
          final degree = firstEducation['degree'] ?? '';
          final institution = firstEducation['institution'] ?? '';
          education = '${degree} ${institution}'.trim();
          if (education.isEmpty) {
            education = 'Not specified';
          }
        }

        // Extract experience information
        String jobTitle = 'Not specified';
        String company = 'Not specified';
        String hireDate = 'Not specified';
        String experience = 'Not specified';

        if (profileData['experience'] != null &&
            (profileData['experience'] as List).isNotEmpty) {
          final firstExperience = profileData['experience'][0];
          jobTitle = firstExperience['title'] ?? 'Not specified';
          company = firstExperience['company'] ?? 'Not specified';

          if (firstExperience['duration'] != null) {
            final fromDate = firstExperience['duration']['from'] ?? '';
            final toDate = firstExperience['duration']['to'] ?? '';
            hireDate = fromDate.isNotEmpty ? fromDate : 'Not specified';
            experience =
                fromDate.isNotEmpty && toDate.isNotEmpty
                    ? '$fromDate - $toDate'
                    : 'Not specified';
          }
        }

        // Create SummaryRequest from profile data with exact mapping
        final request = SummaryRequest(
          firstName: profileData['firstName'] ?? 'Not specified',
          lastName: profileData['lastName'] ?? 'Not specified',
          nationality: 'Not specified', // Not available in profile
          phone: profileData['phone'] ?? 'Not specified',
          dob: profileData['dob'] ?? 'Not specified',
          gender: profileData['gender'] ?? 'Not specified',
          education: education,
          skills: skills,
          experience: experience,
          language: 'English', // Default language
          jobTitle: jobTitle,
          company: company,
          hireDate: hireDate,
          github: profileData['github'] ?? 'Not specified',
          email: profileData['email'] ?? 'Not specified',
          linkedin:
              'Not specified', // Not available in profile (only twitter is available)
          tone: 'Formal', // Always set to Formal as specified
        );

        // Debug: Print the request data
        print('🔍 [GenerateSummaryCubit] Request data: ${request.toJson()}');

        // Now generate the summary
        final summaryResponse = await _dio.post(
          ApiEndpoints.generateSummary,
          data: request.toJson(),
          options: Options(headers: {'Content-Type': 'application/json'}),
        );

        if (summaryResponse.statusCode == 200) {
          final summary = SummaryResponse.fromJson(summaryResponse.data);
          emit(GenerateSummarySuccess(summary));
        } else {
          emit(
            GenerateSummaryFailure('Failed to generate summary from profile'),
          );
        }
      } else {
        emit(GenerateSummaryFailure('Failed to fetch profile data'));
      }
    } catch (e) {
      emit(GenerateSummaryFailure(e.toString()));
    }
  }
}
