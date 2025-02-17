import 'package:equatable/equatable.dart';

abstract class SearchJobPostsState extends Equatable {
  const SearchJobPostsState();

  @override
  List<Object?> get props => [];
}

class SearchJobPostsInitial extends SearchJobPostsState {}

class SearchJobPostsLoading extends SearchJobPostsState {}

class SearchJobPostsSuccess extends SearchJobPostsState {
  final List<Map<String, dynamic>> jobPosts;

  const SearchJobPostsSuccess(this.jobPosts);

  @override
  List<Object?> get props => [jobPosts];
}

class SearchJobPostsFailure extends SearchJobPostsState {
  final String error;

  const SearchJobPostsFailure(this.error);

  @override
  List<Object?> get props => [error];
}