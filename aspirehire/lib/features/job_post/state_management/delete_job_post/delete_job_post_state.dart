import 'package:equatable/equatable.dart';

abstract class DeleteJobPostState extends Equatable {
  const DeleteJobPostState();

  @override
  List<Object?> get props => [];
}

class DeleteJobPostInitial extends DeleteJobPostState {}

class DeleteJobPostLoading extends DeleteJobPostState {}

class DeleteJobPostSuccess extends DeleteJobPostState {
  final String message;

  const DeleteJobPostSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteJobPostFailure extends DeleteJobPostState {
  final String error;

  const DeleteJobPostFailure(this.error);

  @override
  List<Object?> get props => [error];
}