import 'package:equatable/equatable.dart';
import '../../../core/models/Feed.dart';

abstract class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostSuccess extends CreatePostState {}

class CreatePostFailure extends CreatePostState {
  final String error;

  const CreatePostFailure(this.error);

  @override
  List<Object?> get props => [error];
}
