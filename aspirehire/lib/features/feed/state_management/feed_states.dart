import '../../../core/models/Feed.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final FeedResponse feedResponse;

  FeedLoaded(this.feedResponse);
}

class FeedError extends FeedState {
  final String message;

  FeedError(this.message);
}