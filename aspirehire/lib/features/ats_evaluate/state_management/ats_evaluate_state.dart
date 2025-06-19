import 'package:equatable/equatable.dart';
import '../../../core/models/ATSEvaluation.dart';

abstract class ATSEvaluateState extends Equatable {
  const ATSEvaluateState();

  @override
  List<Object?> get props => [];
}

class ATSEvaluateInitial extends ATSEvaluateState {}

class ATSEvaluateLoading extends ATSEvaluateState {}

class ATSEvaluateSuccess extends ATSEvaluateState {
  final ATSEvaluation evaluation;
  const ATSEvaluateSuccess(this.evaluation);
  @override
  List<Object?> get props => [evaluation];
}

class ATSEvaluateFailure extends ATSEvaluateState {
  final String error;
  const ATSEvaluateFailure(this.error);
  @override
  List<Object?> get props => [error];
}
