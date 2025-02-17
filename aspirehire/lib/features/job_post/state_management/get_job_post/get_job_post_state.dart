import 'package:equatable/equatable.dart';

abstract class GetJobPostState extends Equatable {
  const GetJobPostState();

  @override
  List<Object?> get props => [];
}

class GetJobPostInitial extends GetJobPostState {}

class GetJobPostLoading extends GetJobPostState {}

class GetJobPostSuccess extends GetJobPostState {
  final Map<String, dynamic> jobPost;

  const GetJobPostSuccess(this.jobPost);

  @override
  List<Object?> get props => [jobPost];
}

class GetJobPostFailure extends GetJobPostState {
  final String error;

  const GetJobPostFailure(this.error);

  @override
  List<Object?> get props => [error];
}