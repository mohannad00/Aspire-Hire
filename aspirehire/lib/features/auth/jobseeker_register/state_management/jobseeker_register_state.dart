import 'package:equatable/equatable.dart';

abstract class JobSeekerRegisterState extends Equatable {
  const JobSeekerRegisterState();

  @override
  List<Object?> get props => [];
}

class JobSeekerRegisterInitial extends JobSeekerRegisterState {}

class JobSeekerRegisterLoading extends JobSeekerRegisterState {}

class JobSeekerRegisterSuccess extends JobSeekerRegisterState {
  final String message;

  const JobSeekerRegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class JobSeekerRegisterFailure extends JobSeekerRegisterState {
  final String error;

  const JobSeekerRegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}