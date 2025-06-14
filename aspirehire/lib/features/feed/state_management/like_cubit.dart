import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Post.dart';
import 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  LikeCubit() : super(LikeInitial());

  final Dio _dio = Dio();

  Future<void> likeOrDislikePost(
    String token,
    String postId,
    String react,
  ) async {
    print('🔍 [LikeCubit] Like/Dislike post: $postId with react: $react');
    emit(LikeLoading());
    try {
      final request = LikePostRequest()..react = react;

      final response = await _dio.post(
        ApiEndpoints.likeOrDislikePost.replaceAll(':postId', postId),
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
        ),
      );
      print('🔍 [LikeCubit] Like/Dislike response: ${response.data}');
      emit(
        LikeSuccess(
          response.data['message'] ?? 'Action completed successfully',
        ),
      );
    } on DioException catch (e) {
      print('🔍 [LikeCubit] Like/Dislike error: ${e.message}');
      print('🔍 [LikeCubit] Response data: ${e.response?.data}');
      print('🔍 [LikeCubit] Status code: ${e.response?.statusCode}');
      emit(LikeError(e.message ?? 'An error occurred'));
    }
  }
}
