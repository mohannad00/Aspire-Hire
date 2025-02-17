import 'package:equatable/equatable.dart';

abstract class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object?> get props => [];
}

class PasswordResetInitial extends PasswordResetState {}

class PasswordResetLoading extends PasswordResetState {}

class PasswordResetSuccess extends PasswordResetState {
  final String message;

  const PasswordResetSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetFailure extends PasswordResetState {
  final String error;

  const PasswordResetFailure(this.error);

  @override
  List<Object?> get props => [error];
}