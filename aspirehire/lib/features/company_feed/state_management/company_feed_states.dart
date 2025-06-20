import '../../../core/models/Feed.dart';

abstract class CompanyFeedState {}

class CompanyFeedInitial extends CompanyFeedState {}

class CompanyFeedLoading extends CompanyFeedState {}

class CompanyFeedLoaded extends CompanyFeedState {
  final FeedResponse feedResponse;
  CompanyFeedLoaded(this.feedResponse);
}

class CompanyFeedError extends CompanyFeedState {
  final String message;
  CompanyFeedError(this.message);
}
