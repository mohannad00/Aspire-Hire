part of 'update_job_application_cubit.dart';

abstract class UpdateJobApplicationState extends Equatable {
  const UpdateJobApplicationState();

  @override
  List<Object> get props => [];
}

class UpdateJobApplicationInitial extends UpdateJobApplicationState {}

class UpdateJobApplicationLoading extends UpdateJobApplicationState {}

class UpdateJobApplicationSuccess extends UpdateJobApplicationState {
  final UpdateJobApplicationResponse response;

  const UpdateJobApplicationSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class UpdateJobApplicationFailure extends UpdateJobApplicationState {
  final String message;

  const UpdateJobApplicationFailure(this.message);

  @override
  List<Object> get props => [message];
}