import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Comment.dart';
import '../../../core/models/Feed.dart';
import 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final Dio _dio = Dio();

  CommentCubit() : super(CommentInitial());

  // Create Comment
  Future<void> createComment(
    String token,
    String postId,
    CreateCommentRequest request,
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
      final comment = Comment.fromJson(response.data['data']['comment']);
      emit(CommentCreated(comment));
    } on DioException catch (e) {
      emit(CommentError(e.message ?? 'An error occurred'));
    }
  }

  // Update Comment
  Future<void> updateComment(
    String token,
    String postId,
    String commentId,
    UpdateCommentRequest request,
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
      final comments =
          (response.data['data']['comments'] as List<dynamic>)
              .map((item) => Comment.fromJson(item as Map<String, dynamic>))
              .toList();
      emit(CommentsLoaded(comments));
    } on DioException catch (e) {
      emit(CommentError(e.message ?? 'An error occurred'));
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
      final request = LikeCommentRequest()..react = react;
      final response = await _dio.post(
        ApiEndpoints.likeOrDislikeComment
            .replaceAll(':postId', postId)
            .replaceAll(':commentId', commentId),
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );
      final message = LikeCommentResponse.fromJson(response.data).message;
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
