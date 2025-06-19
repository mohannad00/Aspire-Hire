import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/CvRequest.dart';
import '../../../core/models/CvResponse.dart';
import 'generate_cv_state.dart';

class GenerateCvCubit extends Cubit<GenerateCvState> {
  final Dio _dio = Dio();

  GenerateCvCubit() : super(GenerateCvInitial());

  Future<void> generateCv(CvRequest request) async {
    print('DEBUG: Starting generateCv method');
    print('DEBUG: Request data: ${request.toJson()}');
    emit(GenerateCvLoading());

    try {
      print('DEBUG: Making API call to: ${ApiEndpoints.generateCV}');
      final response = await _dio.post(
        ApiEndpoints.generateCV,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.bytes,
        ),
      );

      print('DEBUG: API response status: ${response.statusCode}');
      print('DEBUG: Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final pdfBytes = response.data as List<int>;
        print('DEBUG: PDF bytes received, size: ${pdfBytes.length} bytes');

        final cvResponse = CvResponse.fromBytes(pdfBytes);
        print('DEBUG: CvResponse created successfully');
        print('DEBUG: File name: ${cvResponse.fileName}');
        print(
          'DEBUG: PDF data size in response: ${cvResponse.pdfData.length} bytes',
        );

        emit(GenerateCvSuccess(cvResponse));
        print('DEBUG: GenerateCvSuccess state emitted');
      } else {
        print('DEBUG: API call failed with status: ${response.statusCode}');
        emit(GenerateCvFailure('Failed to generate CV'));
      }
    } catch (e) {
      print('DEBUG: Error in generateCv: $e');
      emit(GenerateCvFailure(e.toString()));
    }
  }

  Future<void> generateCvFromProfile(
    String token,
    String summary,
    String themeColor,
  ) async {
    print('DEBUG: Starting generateCvFromProfile method');
    print('DEBUG: Token: ${token.substring(0, 20)}...');
    print('DEBUG: Summary: $summary');
    print('DEBUG: Theme color: $themeColor');

    emit(GenerateCvLoading());

    try {
      // First, get the user's profile
      print('DEBUG: Fetching user profile from: ${ApiEndpoints.getProfile}');
      final profileResponse = await _dio.get(
        ApiEndpoints.getProfile,
        options: Options(headers: {'Authorization': token}),
      );

      print('DEBUG: Profile response status: ${profileResponse.statusCode}');
      print(
        'DEBUG: Profile response success: ${profileResponse.data['success']}',
      );

      if (profileResponse.statusCode == 200 &&
          profileResponse.data['success'] == true) {
        final profileData = profileResponse.data['data'];
        print('DEBUG: Profile data received: ${profileData.keys.toList()}');

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
        print('DEBUG: Extracted skills: $skills');

        // If no skills found, provide a default
        if (skills.isEmpty) {
          skills = ['General Skills'];
          print('DEBUG: Using default skills');
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
        print('DEBUG: Extracted education: $education');

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
        print('DEBUG: Extracted job title: $jobTitle');
        print('DEBUG: Extracted company: $company');
        print('DEBUG: Extracted experience: $experience');

        // Create CvRequest from profile data
        final cvData = CvData(
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
        );

        final request = CvRequest(
          cvData: cvData,
          summary: summary,
          themeColor: themeColor,
        );

        // Debug: Print the request data
        print('DEBUG: Request data: ${request.toJson()}');

        // Now generate the CV
        print('DEBUG: Making CV generation API call');
        final cvResponse = await _dio.post(
          ApiEndpoints.generateCV,
          data: request.toJson(),
          options: Options(
            headers: {'Content-Type': 'application/json'},
            responseType: ResponseType.bytes,
          ),
        );

        print('DEBUG: CV generation response status: ${cvResponse.statusCode}');
        print(
          'DEBUG: CV generation response data type: ${cvResponse.data.runtimeType}',
        );

        if (cvResponse.statusCode == 200) {
          final pdfBytes = cvResponse.data as List<int>;
          print('DEBUG: PDF bytes received, size: ${pdfBytes.length} bytes');

          final cv = CvResponse.fromBytes(pdfBytes);
          print('DEBUG: CvResponse created successfully');
          print('DEBUG: File name: ${cv.fileName}');
          print('DEBUG: PDF data size in response: ${cv.pdfData.length} bytes');

          emit(GenerateCvSuccess(cv));
          print('DEBUG: GenerateCvSuccess state emitted');
        } else {
          print(
            'DEBUG: CV generation failed with status: ${cvResponse.statusCode}',
          );
          emit(GenerateCvFailure('Failed to generate CV from profile'));
        }
      } else {
        print('DEBUG: Profile fetch failed');
        emit(GenerateCvFailure('Failed to fetch profile data'));
      }
    } catch (e) {
      print('DEBUG: Error in generateCvFromProfile: $e');
      emit(GenerateCvFailure(e.toString()));
    }
  }
}
