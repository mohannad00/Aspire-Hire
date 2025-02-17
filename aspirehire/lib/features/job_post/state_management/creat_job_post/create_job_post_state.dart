import 'package:equatable/equatable.dart';

abstract class CreateJobPostState extends Equatable {
  const CreateJobPostState();

  @override
  List<Object?> get props => [];
}

class CreateJobPostInitial extends CreateJobPostState {}

class CreateJobPostLoading extends CreateJobPostState {}

class CreateJobPostSuccess extends CreateJobPostState {
  final String message;

  const CreateJobPostSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateJobPostFailure extends CreateJobPostState {
  final String error;

  const CreateJobPostFailure(this.error);

  @override
  List<Object?> get props => [error];
}