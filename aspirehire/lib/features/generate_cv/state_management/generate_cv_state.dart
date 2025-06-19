import 'package:equatable/equatable.dart';
import '../../../core/models/CvResponse.dart';

abstract class GenerateCvState extends Equatable {
  const GenerateCvState();

  @override
  List<Object?> get props => [];
}

class GenerateCvInitial extends GenerateCvState {}

class GenerateCvLoading extends GenerateCvState {}

class GenerateCvSuccess extends GenerateCvState {
  final CvResponse cvResponse;

  const GenerateCvSuccess(this.cvResponse);

  @override
  List<Object?> get props => [cvResponse];
}

class GenerateCvFailure extends GenerateCvState {
  final String error;

  const GenerateCvFailure(this.error);

  @override
  List<Object?> get props => [error];
}
