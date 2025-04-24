import '../../../core/models/Feed.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentCreated extends CommentState {
  final Comment comment;

  CommentCreated(this.comment);
}

class CommentUpdated extends CommentState {
  final Comment comment;

  CommentUpdated(this.comment);
}

class CommentsLoaded extends CommentState {
  final List<Comment> comments;

  CommentsLoaded(this.comments);
}

class CommentLiked extends CommentState {
  final String message;

  CommentLiked(this.message);
}

class CommentLikesLoaded extends CommentState {
  final List<React> reacts;

  CommentLikesLoaded(this.reacts);
}

class CommentError extends CommentState {
  final String message;

  CommentError(this.message);
}