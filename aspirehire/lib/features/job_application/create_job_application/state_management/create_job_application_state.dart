part of 'create_job_application_cubit.dart';

abstract class CreateJobApplicationState extends Equatable {
  const CreateJobApplicationState();

  @override
  List<Object> get props => [];
}

class CreateJobApplicationInitial extends CreateJobApplicationState {}

class CreateJobApplicationLoading extends CreateJobApplicationState {}

class CreateJobApplicationSuccess extends CreateJobApplicationState {
  final CreateJobApplicationResponse response;

  const CreateJobApplicationSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class CreateJobApplicationFailure extends CreateJobApplicationState {
  final String message;

  const CreateJobApplicationFailure(this.message);

  @override
  List<Object> get props => [message];
}