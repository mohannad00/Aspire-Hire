part of 'get_job_application_cubit.dart';

abstract class GetJobApplicationState extends Equatable {
  const GetJobApplicationState();

  @override
  List<Object> get props => [];
}

class GetJobApplicationInitial extends GetJobApplicationState {}

class GetJobApplicationLoading extends GetJobApplicationState {}

class GetJobApplicationSuccess extends GetJobApplicationState {
  final GetJobApplicationResponse response;

  const GetJobApplicationSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class GetJobApplicationFailure extends GetJobApplicationState {
  final String message;

  const GetJobApplicationFailure(this.message);

  @override
  List<Object> get props => [message];
}