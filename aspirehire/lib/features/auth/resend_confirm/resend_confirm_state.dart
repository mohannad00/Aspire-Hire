import 'package:equatable/equatable.dart';

abstract class ResendConfirmState extends Equatable {
  const ResendConfirmState();

  @override
  List<Object?> get props => [];
}

class ResendConfirmInitial extends ResendConfirmState {}

class ResendConfirmLoading extends ResendConfirmState {}

class ResendConfirmSuccess extends ResendConfirmState {
  final String message;

  const ResendConfirmSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResendConfirmFailure extends ResendConfirmState {
  final String error;

  const ResendConfirmFailure(this.error);

  @override
  List<Object?> get props => [error];
}