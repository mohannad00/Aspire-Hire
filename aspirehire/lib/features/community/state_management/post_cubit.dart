import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Feed.dart';
import '../../../core/models/Post.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final Dio _dio = Dio();

  PostCubit() : super(PostInitial());

  // Create Post
  Future<void> createPost(String token, CreatePostRequest request) async {
    emit(PostLoading());
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
        ApiEndpoints.createPost,
        data: formData,
        options: Options(headers: {'Authorization': token}),
      );
      final post = Post.fromJson(response.data['data']['post']);
      emit(PostCreated(post));
    } on DioException catch (e) {
      emit(PostError(e.message ?? 'An error occurred'));
    }
  }

  // Get Post
  Future<void> getPost(String token, String postId) async {
    emit(PostLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getPost.replaceAll(':postId', postId),
        options: Options(headers: {'Authorization': token}),
      );
      final post = Post.fromJson(response.data['data']['post']);
      emit(PostLoaded(post));
    } on DioException catch (e) {
      emit(PostError(e.message ?? 'An error occurred'));
    }
  }

  // Get All Likes of Post
  Future<void> getAllLikesOfPost(String token, String postId) async {
    emit(PostLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllLikesOfPost.replaceAll(':postId', postId),
        options: Options(headers: {'Authorization': token}),
      );
      final reacts =
          (response.data['data']['reacts'] as List<dynamic>)
              .map((item) => React.fromJson(item as Map<String, dynamic>))
              .toList();
      emit(PostLikesLoaded(reacts));
    } on DioException catch (e) {
      emit(PostError(e.message ?? 'An error occurred'));
    }
  }

  // Get Archived Posts
  Future<void> getArchivedPosts(String token) async {
    emit(PostLoading());
    try {
      final response = await _dio.get(
        ApiEndpoints.getArchivedPosts,
        options: Options(headers: {'Authorization': token}),
      );
      final posts =
          (response.data['data']['posts'] as List<dynamic>)
              .map((item) => Post.fromJson(item as Map<String, dynamic>))
              .toList();
      emit(ArchivedPostsLoaded(posts));
    } on DioException catch (e) {
      emit(PostError(e.message ?? 'An error occurred'));
    }
  }

  // Delete Post
  Future<void> deletePost(String token, String postId) async {
    emit(PostLoading());
    try {
      final response = await _dio.delete(
        ApiEndpoints.deletePost.replaceAll(':postId', postId),
        options: Options(headers: {'Authorization': token}),
      );
      final message = DeletePostResponse.fromJson(response.data).message;
      emit(PostDeleted(message));
    } on DioException catch (e) {
      emit(PostError(e.message ?? 'An error occurred'));
    }
  }

  // Archive Post
  Future<void> archivePost(String token, String postId) async {
    emit(PostLoading());
    try {
      final response = await _dio.patch(
        ApiEndpoints.archivePost.replaceAll(':postId', postId),
        options: Options(headers: {'Authorization': token}),
      );
      final message = ArchivePostResponse.fromJson(response.data).message;
      emit(PostArchived(message));
    } on DioException catch (e) {
      emit(PostError(e.message ?? 'An error occurred'));
    }
  }

  // Update Post
  Future<void> updatePost(
    String token,
    String postId,
    UpdatePostRequest request,
  ) async {
    emit(PostLoading());
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
        ApiEndpoints.updatePost.replaceAll(':postId', postId),
        data: formData,
        options: Options(headers: {'Authorization': token}),
      );
      final post = Post.fromJson(response.data['data']['post']);
      emit(PostUpdated(post));
    } on DioException catch (e) {
      emit(PostError(e.message ?? 'An error occurred'));
    }
  }

  // Like or Dislike Post
  Future<void> likeOrDislikePost(
    String token,
    String postId,
    String react,
  ) async {
    emit(PostLoading());
    try {
      final request = LikePostRequest()..react = react;
      final response = await _dio.post(
        ApiEndpoints.likeOrDislikePost.replaceAll(':postId', postId),
        data: request.toJson(),
        options: Options(headers: {'Authorization': token}),
      );
      final message = LikePostResponse.fromJson(response.data).message;
      emit(PostLiked(message));
    } on DioException catch (e) {
      emit(PostError(e.message ?? 'An error occurred'));
    }
  }
}
