part of 'create_job_application_cubit.dart';

abstract class CreateJobApplicationState extends Equatable {
  const CreateJobApplicationState();

  @override
  List<Object> get props => [];
}

class CreateJobApplicationInitial extends CreateJobApplicationState {}

class CreateJobApplicationLoading extends CreateJobApplicationState {}

class CreateJobApplicationSuccess extends CreateJobApplicationState {
  const CreateJobApplicationSuccess();

  @override
  List<Object> get props => [];
}

class CreateJobApplicationFailure extends CreateJobApplicationState {
  final String message;

  const CreateJobApplicationFailure(this.message);

  @override
  List<Object> get props => [message];
}
