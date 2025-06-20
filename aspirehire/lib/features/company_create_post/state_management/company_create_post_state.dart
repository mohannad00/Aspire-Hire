import 'package:equatable/equatable.dart';
import '../../../core/models/Feed.dart';

abstract class CompanyCreatePostState extends Equatable {
  const CompanyCreatePostState();

  @override
  List<Object?> get props => [];
}

class CompanyCreatePostInitial extends CompanyCreatePostState {}

class CompanyCreatePostLoading extends CompanyCreatePostState {}

class CompanyCreatePostSuccess extends CompanyCreatePostState {}

class CompanyCreatePostFailure extends CompanyCreatePostState {
  final String error;

  const CompanyCreatePostFailure(this.error);

  @override
  List<Object?> get props => [error];
}
