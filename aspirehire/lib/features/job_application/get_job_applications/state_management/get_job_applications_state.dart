part of 'get_job_applications_cubit.dart';

abstract class GetJobApplicationsState extends Equatable {
  const GetJobApplicationsState();

  @override
  List<Object> get props => [];
}

class GetJobApplicationsInitial extends GetJobApplicationsState {}

class GetJobApplicationsLoading extends GetJobApplicationsState {}

class GetJobApplicationsSuccess extends GetJobApplicationsState {
  final GetJobApplicationsResponse response;

  const GetJobApplicationsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class GetJobApplicationsFailure extends GetJobApplicationsState {
  final String message;

  const GetJobApplicationsFailure(this.message);

  @override
  List<Object> get props => [message];
}