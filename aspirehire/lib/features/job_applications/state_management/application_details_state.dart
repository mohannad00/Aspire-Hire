part of 'application_details_cubit.dart';

abstract class ApplicationDetailsState extends Equatable {
  const ApplicationDetailsState();

  @override
  List<Object?> get props => [];
}

class ApplicationDetailsInitial extends ApplicationDetailsState {}

class ApplicationDetailsLoading extends ApplicationDetailsState {}

class ApplicationDetailsSuccess extends ApplicationDetailsState {
  final JobApplication application;

  const ApplicationDetailsSuccess(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationDetailsFailure extends ApplicationDetailsState {
  final String message;

  const ApplicationDetailsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ApplicationDetailsActionLoading extends ApplicationDetailsState {}

class ApplicationDetailsActionSuccess extends ApplicationDetailsState {
  final String message;

  const ApplicationDetailsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ApplicationDetailsActionFailure extends ApplicationDetailsState {
  final String message;

  const ApplicationDetailsActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
