import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Feed.dart';
import '../../../core/models/Comment.dart' as comment_models;
import 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final Dio _dio = Dio();

  CommentCubit() : super(CommentInitial());

  // Create Comment
  Future<void> createComment(
    String token,
    String postId,
    comment_models.CreateCommentRequest request,
  ) async {
    emit(CommentLoading());
    try {
      FormData formData = FormData.fromMap(request.toJson());
      if (request.attachment != null) {
        formData.files.add(
          MapEntry(
            'attachment',
            await MultipartFile.fromFile(request.attachment!),
          ),
        );
      }
      final response = await _dio.post(
        ApiEndpoints.createComment.replaceAll(':postId', postId),
        data: formData,
        options: Options(headers: {'Authorization': token}),
      );

      print('🔍 [CommentCubit] Create comment response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          print('🔍 [CommentCubit] Comment created successfully');
          emit(CommentCreated());
        } else {
          final error = responseData['message'] ?? 'Failed to create comment';
          print('🔍 [CommentCubit] API Error: $error');
          emit(CommentError(error));
        }
      } else {
        final error = response.data['message'] ?? 'Failed to create comment';
        print('🔍 [CommentCubit] HTTP Error: $error');
        emit(CommentError(error));
      }
    } on DioException catch (e) {
      print('🔍 [CommentCubit] DioException: ${e.message}');
      print('🔍 [CommentCubit] Response data: ${e.response?.data}');

      String errorMessage = 'Failed to create comment. Please try again.';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      emit(CommentError(errorMessage));
    } catch (e) {
      print('🔍 [CommentCubit] Unexpected error: $e');
      emit(CommentError('An unexpected error occurred. Please try again.'));
    }
  }

  // Update Comment
  Future<void> updateComment(
    String token,
    String postId,
    String commentId,
    comment_models.UpdateCommentRequest request,
  ) async {
    emit(CommentLoading());
    try {
      FormData formData = FormData.fromMap(request.toJson());
      if (request.attachment != null) {
        formData.files.add(
          MapEntry(
            'attachment',
            await MultipartFile.fromFile(request.attachment!),
          ),
        );
      }
      final response = await _dio.put(
        ApiEndpoints.updateComment
            .replaceAll(':postId', postId)
            .replaceAll(':commentId', commentId),
        data: formData,
        options: Options(headers: {'Authorization': token}),
      );
      final comment = Comment.fromJson(response.data['data']['comment']);
      emit(CommentUpdated(comment));
    } on DioException catch (e) {
      emit(CommentError(e.message ?? 'An error occurred'));
    }
  }

  // Get All Comments
  Future<void> getAllComments(String token, String postId) async {
    emit(CommentLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllComments.replaceAll(':postId', postId),
        options: Options(headers: {'Authorization': token}),
      );
      print(
        "*******************************************************************",
      );
      print(response.data);
      print(
        "*******************************************************************",
      );

      // Handle different possible response structures
      List<dynamic> commentsList = [];

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is Map<String, dynamic> && data['comments'] is List) {
          commentsList = data['comments'] as List<dynamic>;
        } else if (data is List) {
          // If data is directly a list of comments
          commentsList = data;
        } else if (response.data['comments'] is List) {
          // If comments is at the root level
          commentsList = response.data['comments'] as List<dynamic>;
        }
      } else if (response.data is List) {
        // If the entire response is a list of comments
        commentsList = response.data as List<dynamic>;
      }

      print("Comments list length: ${commentsList.length}");

      final comments =
          commentsList
              .map((item) {
                try {
                  if (item is Map<String, dynamic>) {
                    return Comment.fromJson(item);
                  } else {
                    print("Invalid comment item: $item");
                    return null;
                  }
                } catch (e) {
                  print("Error parsing comment: $e");
                  return null;
                }
              })
              .where((comment) => comment != null)
              .cast<Comment>()
              .toList();

      emit(CommentsLoaded(comments));
    } on DioException catch (e) {
      print("DioException in getAllComments: ${e.message}");
      print("Response data: ${e.response?.data}");
      print("Status code: ${e.response?.statusCode}");

      // Handle 500 status code - show no comments yet
      if (e.response?.statusCode == 500) {
        print("Server error (500) - treating as no comments yet");
        emit(CommentsLoaded([])); // Empty list means no comments
      } else {
        emit(CommentError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      print("Unexpected error in getAllComments: $e");
      emit(CommentError('An unexpected error occurred: $e'));
    }
  }

  // Like or Dislike Comment
  Future<void> likeOrDislikeComment(
    String token,
    String postId,
    String commentId,
    String react,
  ) async {
    emit(CommentLoading());
    try {
      final request = comment_models.LikeCommentRequest()..react = react;
      final response = await _dio.post(
        ApiEndpoints.likeOrDislikeComment
            .replaceAll(':postId', postId)
            .replaceAll(':commentId', commentId),
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );
      final message =
          comment_models.LikeCommentResponse.fromJson(response.data).message;
      emit(CommentLiked(message));
    } on DioException catch (e) {
      emit(CommentError(e.message ?? 'An error occurred'));
    }
  }

  // Get All Likes of Comment
  Future<void> getAllLikesOfComment(
    String token,
    String postId,
    String commentId,
  ) async {
    emit(CommentLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllLikesOfComment
            .replaceAll(':postId', postId)
            .replaceAll(':commentId', commentId),
        options: Options(headers: {'Authorization': token}),
      );
      final reacts =
          (response.data['data']['reacts'] as List<dynamic>)
              .map((item) => React.fromJson(item as Map<String, dynamic>))
              .toList();
      emit(CommentLikesLoaded(reacts));
    } on DioException catch (e) {
      emit(CommentError(e.message ?? 'An error occurred'));
    }
  }
}
