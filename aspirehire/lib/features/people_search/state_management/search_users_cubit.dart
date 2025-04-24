import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../core/models/SearchProfileDTO.dart';
import 'search_users_state.dart';
import '../../../config/datasources/api/end_points.dart';

class SearchUsersCubit extends Cubit<SearchUsersState> {
  final Dio _dio = Dio();

  SearchUsersCubit() : super(SearchUsersInitial());

  Future<void> searchUsers(String token, String query) async {
    emit(SearchUsersLoading());
    try {
      final response = await _dio.get(
        '${ApiEndpoints.searchUsers.split('?q:query')[0]}?q=$query',
        options: Options(headers: {'Authorization': token}),
      );

      if (response.data['success'] == true) {
        final List<dynamic> usersJson = response.data['data'];
        final users = usersJson.map((json) => UserProfile.fromJson(json)).toList();
        emit(SearchUsersLoaded(users));
      } else {
        emit(const SearchUsersError('Failed to fetch search results'));
      }
    } on DioException catch (e) {
      emit(SearchUsersError(e.message ?? 'An error occurred while searching'));
    }
  }

  void clearSearch() {
    emit(SearchUsersInitial());
  }
}