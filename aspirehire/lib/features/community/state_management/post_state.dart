import '../../../core/models/Feed.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostCreated extends PostState {
  final Post post;

  PostCreated(this.post);
}

class PostLoaded extends PostState {
  final Post post;

  PostLoaded(this.post);
}

class PostLikesLoaded extends PostState {
  final List<React> reacts;

  PostLikesLoaded(this.reacts);
}

class ArchivedPostsLoaded extends PostState {
  final List<Post> posts;

  ArchivedPostsLoaded(this.posts);
}

class PostDeleted extends PostState {
  final String message;

  PostDeleted(this.message);
}

class PostArchived extends PostState {
  final String message;

  PostArchived(this.message);
}

class PostUpdated extends PostState {
  final Post post;

  PostUpdated(this.post);
}

class PostLiked extends PostState {
  final String message;

  PostLiked(this.message);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}