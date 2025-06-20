abstract class CompanyLikeState {}

class CompanyLikeInitial extends CompanyLikeState {}

class CompanyLikeLoading extends CompanyLikeState {}

class CompanyLikeSuccess extends CompanyLikeState {
  final String message;
  CompanyLikeSuccess(this.message);
}

class CompanyLikeError extends CompanyLikeState {
  final String message;
  CompanyLikeError(this.message);
}
