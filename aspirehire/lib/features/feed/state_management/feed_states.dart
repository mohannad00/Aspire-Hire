import '../../../core/models/Post.dart';

abstract class FeedState {
  const FeedState();
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final FeedResponse feedResponse;

  const FeedLoaded({required this.feedResponse});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedLoaded &&
          runtimeType == other.runtimeType &&
          feedResponse == other.feedResponse;

  @override
  int get hashCode => feedResponse.hashCode;
}

class FeedError extends FeedState {
  final String message;

  const FeedError({required this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}