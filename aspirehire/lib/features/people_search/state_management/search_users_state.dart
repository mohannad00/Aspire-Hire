import 'package:equatable/equatable.dart';
import '../../../core/models/SearchProfileDTO.dart';

abstract class SearchUsersState extends Equatable {
  const SearchUsersState();

  @override
  List<Object?> get props => [];
}

class SearchUsersInitial extends SearchUsersState {}

class SearchUsersLoading extends SearchUsersState {}

class SearchUsersLoaded extends SearchUsersState {
  final List<UserProfile> users;

  const SearchUsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class SearchUsersError extends SearchUsersState {
  final String message;

  const SearchUsersError(this.message);

  @override
  List<Object?> get props => [message];
}