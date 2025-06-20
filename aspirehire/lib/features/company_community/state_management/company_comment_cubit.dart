import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Feed.dart';
import '../../../core/models/Comment.dart' as comment_models;
import 'company_comment_state.dart';

class CompanyCommentCubit extends Cubit<CompanyCommentState> {
  final Dio _dio = Dio();

  CompanyCommentCubit() : super(CompanyCommentInitial());

  // Create Comment
  Future<void> createComment(
    String token,
    String postId,
    comment_models.CreateCommentRequest request,
  ) async {
    emit(CompanyCommentLoading());
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          emit(CompanyCommentCreated());
        } else {
          final error = responseData['message'] ?? 'Failed to create comment';
          emit(CompanyCommentError(error));
        }
      } else {
        final error = response.data['message'] ?? 'Failed to create comment';
        emit(CompanyCommentError(error));
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to create comment. Please try again.';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      emit(CompanyCommentError(errorMessage));
    } catch (e) {
      emit(
        CompanyCommentError('An unexpected error occurred. Please try again.'),
      );
    }
  }

  // Update Comment
  Future<void> updateComment(
    String token,
    String postId,
    String commentId,
    comment_models.UpdateCommentRequest request,
  ) async {
    emit(CompanyCommentLoading());
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
      emit(CompanyCommentUpdated(comment));
    } on DioException catch (e) {
      emit(CompanyCommentError(e.message ?? 'An error occurred'));
    }
  }

  // Get All Comments
  Future<void> getAllComments(String token, String postId) async {
    emit(CompanyCommentLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllComments.replaceAll(':postId', postId),
        options: Options(headers: {'Authorization': token}),
      );
      List<dynamic> commentsList = [];
      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is Map<String, dynamic> && data['comments'] is List) {
          commentsList = data['comments'] as List<dynamic>;
        } else if (data is List) {
          commentsList = data;
        } else if (response.data['comments'] is List) {
          commentsList = response.data['comments'] as List<dynamic>;
        }
      } else if (response.data is List) {
        commentsList = response.data as List<dynamic>;
      }
      final comments =
          commentsList
              .map((item) {
                try {
                  if (item is Map<String, dynamic>) {
                    return Comment.fromJson(item);
                  } else {
                    return null;
                  }
                } catch (e) {
                  return null;
                }
              })
              .where((comment) => comment != null)
              .cast<Comment>()
              .toList();
      emit(CompanyCommentsLoaded(comments));
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        emit(CompanyCommentsLoaded([]));
      } else {
        emit(CompanyCommentError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(CompanyCommentError('An unexpected error occurred: $e'));
    }
  }

  // Like or Dislike Comment
  Future<void> likeOrDislikeComment(
    String token,
    String postId,
    String commentId,
    String react,
  ) async {
    emit(CompanyCommentLoading());
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
      emit(CompanyCommentLiked(message));
    } on DioException catch (e) {
      emit(CompanyCommentError(e.message ?? 'An error occurred'));
    }
  }
}
