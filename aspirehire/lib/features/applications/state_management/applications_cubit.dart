import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../core/models/Application.dart';
import '../../../core/models/JobPost.dart';
import '../../../core/models/Company.dart';
import '../../../core/models/Resume.dart';
import '../../../config/datasources/api/end_points.dart';
import '../../../config/datasources/cache/shared_pref.dart';
import 'applications_state.dart';

class ApplicationsCubit extends Cubit<ApplicationsState> {
  ApplicationsCubit() : super(ApplicationsInitial());

  Future<void> fetchApplications() async {
    emit(ApplicationsLoading());
    try {
      final token = await CacheHelper.getData('token');
      final dio = Dio();
      final response = await dio.get(
        ApiEndpoints.getApplications,
        options: Options(headers: {'Authorization': token}),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<Application> applications =
            (response.data['data'] as List)
                .map((e) => Application.fromJson(e as Map<String, dynamic>))
                .toList();
        emit(ApplicationsLoaded(applications));
      } else {
        emit(ApplicationsError('Failed to load applications'));
      }
    } catch (e) {
      emit(ApplicationsError('Failed to load applications'));
    }
  }
}
