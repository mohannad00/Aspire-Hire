import 'package:equatable/equatable.dart';

abstract class EmployeeRegisterState extends Equatable {
  const EmployeeRegisterState();

  @override
  List<Object?> get props => [];
}

class EmployeeRegisterInitial extends EmployeeRegisterState {}

class EmployeeRegisterLoading extends EmployeeRegisterState {}

class EmployeeRegisterSuccess extends EmployeeRegisterState {
  final String message;

  const EmployeeRegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeeRegisterFailure extends EmployeeRegisterState {
  final String error;

  const EmployeeRegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}