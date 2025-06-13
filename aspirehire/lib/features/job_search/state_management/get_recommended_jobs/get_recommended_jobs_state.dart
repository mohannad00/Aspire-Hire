import 'package:equatable/equatable.dart';
import '../../../../core/models/RecommendedJobPost.dart';

abstract class GetRecommendedJobsState extends Equatable {
  const GetRecommendedJobsState();

  @override
  List<Object?> get props => [];
}

class GetRecommendedJobsInitial extends GetRecommendedJobsState {}

class GetRecommendedJobsLoading extends GetRecommendedJobsState {}

class GetRecommendedJobsSuccess extends GetRecommendedJobsState {
  final List<RecommendedJobData> recommendedJobs;

  const GetRecommendedJobsSuccess(this.recommendedJobs);

  @override
  List<Object?> get props => [recommendedJobs];
}

class GetRecommendedJobsFailure extends GetRecommendedJobsState {
  final String error;

  const GetRecommendedJobsFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class GetRecommendedJobsNoToken extends GetRecommendedJobsState {}
