import 'package:equatable/equatable.dart';

abstract class RequestPasswordResetState extends Equatable {
  const RequestPasswordResetState();

  @override
  List<Object?> get props => [];
}

class RequestPasswordResetInitial extends RequestPasswordResetState {}

class RequestPasswordResetLoading extends RequestPasswordResetState {}

class RequestPasswordResetSuccess extends RequestPasswordResetState {
  final String message;

  const RequestPasswordResetSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RequestPasswordResetFailure extends RequestPasswordResetState {
  final String error;

  const RequestPasswordResetFailure(this.error);

  @override
  List<Object?> get props => [error];
}