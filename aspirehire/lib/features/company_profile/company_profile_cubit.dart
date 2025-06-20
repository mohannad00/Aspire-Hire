import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../core/models/Company.dart';
import '../../config/datasources/api/end_points.dart';
import 'company_profile_state.dart';

class CompanyProfileCubit extends Cubit<CompanyProfileState> {
  final Dio _dio = Dio();

  CompanyProfileCubit() : super(CompanyProfileInitial());

  Future<void> profile(String token) async {
    emit(CompanyProfileLoading());
    try {
      final url = ApiEndpoints.getProfile;
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': token},
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');
      print('55555555555555555555555555555555555555');

      print(response.data);
      if (response.data['success'] == true) {
        final companyProfileResponse = CompanyProfileResponse.fromJson(
          response.data,
        );
        emit(CompanyProfileLoaded(companyProfileResponse.data));
      } else {
        emit(
          CompanyProfileError(
            response.data['message'] ?? 'Failed to load company profile',
          ),
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.response?.data != null && e.response!.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      emit(CompanyProfileError(errorMessage));
    } catch (e) {
      emit(CompanyProfileError('Unexpected error: $e'));
    }
  }
}
