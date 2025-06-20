import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../core/models/Post.dart';
import 'company_like_state.dart';

class CompanyLikeCubit extends Cubit<CompanyLikeState> {
  CompanyLikeCubit() : super(CompanyLikeInitial());

  final Dio _dio = Dio();

  Future<void> likeOrDislikePost(
    String token,
    String postId,
    String react,
  ) async {
    print('[CompanyLikeCubit] Like/Dislike post: $postId with react: $react');
    emit(CompanyLikeLoading());
    try {
      final request = LikePostRequest()..react = react;
      final response = await _dio.post(
        ApiEndpoints.likeOrDislikePost.replaceAll(':postId', postId),
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
        ),
      );
      print('[CompanyLikeCubit] Like/Dislike response: ${response.data}');
      emit(
        CompanyLikeSuccess(
          response.data['message'] ?? 'Action completed successfully',
        ),
      );
    } on DioException catch (e) {
      print('[CompanyLikeCubit] Like/Dislike error: ${e.message}');
      print('[CompanyLikeCubit] Response data: ${e.response?.data}');
      print('[CompanyLikeCubit] Status code: ${e.response?.statusCode}');
      emit(CompanyLikeError(e.message ?? 'An error occurred'));
    }
  }
}
