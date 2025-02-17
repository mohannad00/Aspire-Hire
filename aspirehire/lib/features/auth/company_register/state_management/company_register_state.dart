import 'package:equatable/equatable.dart';

abstract class CompanyRegisterState extends Equatable {
  const CompanyRegisterState();

  @override
  List<Object?> get props => [];
}

class CompanyRegisterInitial extends CompanyRegisterState {}

class CompanyRegisterLoading extends CompanyRegisterState {}

class CompanyRegisterSuccess extends CompanyRegisterState {
  final String message;

  const CompanyRegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CompanyRegisterFailure extends CompanyRegisterState {
  final String error;

  const CompanyRegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}