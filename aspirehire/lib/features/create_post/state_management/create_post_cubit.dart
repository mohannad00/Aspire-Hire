import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Feed.dart';
import '../../../core/models/Post.dart';
import 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final Dio _dio = Dio();

  CreatePostCubit() : super(CreatePostInitial());

  Future<void> createPost(String token, CreatePostRequest request) async {
    print('🔍 [CreatePostCubit] Starting createPost');
    emit(CreatePostLoading());

    try {
      print('🔍 [CreatePostCubit] Creating FormData');
      FormData formData = FormData.fromMap(request.toJson());

      if (request.attachment != null) {
        print('🔍 [CreatePostCubit] Adding attachment: ${request.attachment}');

        // Debug: Get file extension and MIME type
        final String filePath = request.attachment!;
        final String extension = filePath.split('.').last.toLowerCase();
        final String mimeType = 'image/$extension';

        print('🔍 [CreatePostCubit] File extension: $extension');
        print('🔍 [CreatePostCubit] MIME type being sent: $mimeType');

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
        '🔍 [CreatePostCubit] Making API call to: ${ApiEndpoints.createPost}',
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

      print('🔍 [CreatePostCubit] Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        print(
          '🔍 [CreatePostCubit] Response success field: ${responseData['success']}',
        );
        if (responseData['success'] == true) {
          print('🔍 [CreatePostCubit] Emitting CreatePostSuccess');
          emit(CreatePostSuccess());
        } else {
          final error = responseData['message'] ?? 'Failed to create post';
          print('🔍 [CreatePostCubit] API Error: $error');
          emit(CreatePostFailure(error));
        }
      } else {
        final error = response.data['message'] ?? 'Failed to create post';
        print('🔍 [CreatePostCubit] HTTP Error: $error');
        emit(CreatePostFailure(error));
      }
    } on DioException catch (e) {
      print('🔍 [CreatePostCubit] DioException: ${e.message}');
      print('🔍 [CreatePostCubit] Response data: ${e.response?.data}');
      print('🔍 [CreatePostCubit] Status code: ${e.response?.statusCode}');

      String errorMessage = 'An error occurred while creating the post';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(CreatePostFailure(errorMessage));
    } catch (e) {
      print('🔍 [CreatePostCubit] Unexpected error: $e');
      emit(CreatePostFailure('An unexpected error occurred: $e'));
    }
  }
}
