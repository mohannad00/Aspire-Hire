part of 'job_applications_cubit.dart';

abstract class JobApplicationsState extends Equatable {
  const JobApplicationsState();

  @override
  List<Object> get props => [];
}

class JobApplicationsInitial extends JobApplicationsState {}

class JobApplicationsLoading extends JobApplicationsState {}

class JobApplicationsSuccess extends JobApplicationsState {
  final List<JobApplication> applications;

  const JobApplicationsSuccess(this.applications);

  @override
  List<Object> get props => [applications];
}

class JobApplicationsFailure extends JobApplicationsState {
  final String message;

  const JobApplicationsFailure(this.message);

  @override
  List<Object> get props => [message];
}
