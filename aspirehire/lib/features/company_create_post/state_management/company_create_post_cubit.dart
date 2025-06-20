import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Feed.dart';
import '../../../core/models/Post.dart';
import 'company_create_post_state.dart';

class CompanyCreatePostCubit extends Cubit<CompanyCreatePostState> {
  final Dio _dio = Dio();

  CompanyCreatePostCubit() : super(CompanyCreatePostInitial());

  Future<void> createPost(String token, CreatePostRequest request) async {
    print('🔍 [CompanyCreatePostCubit] Starting createPost');
    emit(CompanyCreatePostLoading());

    try {
      print('🔍 [CompanyCreatePostCubit] Creating FormData');
      FormData formData = FormData.fromMap(request.toJson());

      if (request.attachment != null) {
        print(
          '🔍 [CompanyCreatePostCubit] Adding attachment: ${request.attachment}',
        );

        // Debug: Get file extension and MIME type
        final String filePath = request.attachment!;
        final String extension = filePath.split('.').last.toLowerCase();
        final String mimeType = 'image/$extension';

        print('🔍 [CompanyCreatePostCubit] File extension: $extension');
        print('🔍 [CompanyCreatePostCubit] MIME type being sent: $mimeType');

        formData.files.add(
          MapEntry(
            'attachment',
            await MultipartFile.fromFile(
              request.attachment!,
              filename: 'image.$extension',
              contentType: DioMediaType.parse(mimeType),
            ),
          ),
        );
      }

      print(
        '🔍 [CompanyCreatePostCubit] Making API call to: ${ApiEndpoints.createPost}',
      );
      final response = await _dio.post(
        ApiEndpoints.createPost,
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('🔍 [CompanyCreatePostCubit] Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        print(
          '🔍 [CompanyCreatePostCubit] Response success field: ${responseData['success']}',
        );
        if (responseData['success'] == true) {
          print(
            '🔍 [CompanyCreatePostCubit] Emitting CompanyCreatePostSuccess',
          );
          emit(CompanyCreatePostSuccess());
        } else {
          final error = responseData['message'] ?? 'Failed to create post';
          print('🔍 [CompanyCreatePostCubit] API Error: $error');
          emit(CompanyCreatePostFailure(error));
        }
      } else {
        final error = response.data['message'] ?? 'Failed to create post';
        print('🔍 [CompanyCreatePostCubit] HTTP Error: $error');
        emit(CompanyCreatePostFailure(error));
      }
    } on DioException catch (e) {
      print('🔍 [CompanyCreatePostCubit] DioException: ${e.message}');
      print('🔍 [CompanyCreatePostCubit] Response data: ${e.response?.data}');
      print(
        '🔍 [CompanyCreatePostCubit] Status code: ${e.response?.statusCode}',
      );

      String errorMessage = 'An error occurred while creating the post';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(CompanyCreatePostFailure(errorMessage));
    } catch (e) {
      print('🔍 [CompanyCreatePostCubit] Unexpected error: $e');
      emit(CompanyCreatePostFailure('An unexpected error occurred: $e'));
    }
  }
}
