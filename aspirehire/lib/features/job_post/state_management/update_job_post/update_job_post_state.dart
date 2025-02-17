import 'package:equatable/equatable.dart';

abstract class UpdateJobPostState extends Equatable {
  const UpdateJobPostState();

  @override
  List<Object?> get props => [];
}

class UpdateJobPostInitial extends UpdateJobPostState {}

class UpdateJobPostLoading extends UpdateJobPostState {}

class UpdateJobPostSuccess extends UpdateJobPostState {
  final String message;

  const UpdateJobPostSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateJobPostFailure extends UpdateJobPostState {
  final String error;

  const UpdateJobPostFailure(this.error);

  @override
  List<Object?> get props => [error];
}