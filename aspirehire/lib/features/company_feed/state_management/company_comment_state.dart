import '../../../core/models/Feed.dart';

abstract class CompanyCommentState {}

class CompanyCommentInitial extends CompanyCommentState {}

class CompanyCommentLoading extends CompanyCommentState {}

class CompanyCommentCreated extends CompanyCommentState {}

class CompanyCommentUpdated extends CompanyCommentState {
  final Comment comment;
  CompanyCommentUpdated(this.comment);
}

class CompanyCommentsLoaded extends CompanyCommentState {
  final List<Comment> comments;
  CompanyCommentsLoaded(this.comments);
}

class CompanyCommentLiked extends CompanyCommentState {
  final String message;
  CompanyCommentLiked(this.message);
}

class CompanyCommentLikesLoaded extends CompanyCommentState {
  final List<React> reacts;
  CompanyCommentLikesLoaded(this.reacts);
}

class CompanyCommentError extends CompanyCommentState {
  final String message;
  CompanyCommentError(this.message);
}
