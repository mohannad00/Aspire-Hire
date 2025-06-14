abstract class LikeState {}

class LikeInitial extends LikeState {}

class LikeLoading extends LikeState {}

class LikeSuccess extends LikeState {
  final String message;

  LikeSuccess(this.message);
}

class LikeError extends LikeState {
  final String message;

  LikeError(this.message);
}
