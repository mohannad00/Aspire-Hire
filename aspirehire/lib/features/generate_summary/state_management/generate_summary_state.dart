import 'package:equatable/equatable.dart';
import '../../../core/models/SummaryResponse.dart';

abstract class GenerateSummaryState extends Equatable {
  const GenerateSummaryState();

  @override
  List<Object?> get props => [];
}

class GenerateSummaryInitial extends GenerateSummaryState {}

class GenerateSummaryLoading extends GenerateSummaryState {}

class GenerateSummarySuccess extends GenerateSummaryState {
  final SummaryResponse summary;
  const GenerateSummarySuccess(this.summary);
  @override
  List<Object?> get props => [summary];
}

class GenerateSummaryFailure extends GenerateSummaryState {
  final String error;
  const GenerateSummaryFailure(this.error);
  @override
  List<Object?> get props => [error];
}
