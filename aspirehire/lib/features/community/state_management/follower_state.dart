import '../../../core/models/Follower.dart';

abstract class FollowerState {}

class FollowerInitial extends FollowerState {}

class FollowerLoading extends FollowerState {}

class FollowerActionSuccess extends FollowerState {
  final String message;

  FollowerActionSuccess(this.message);
}

class FollowersLoaded extends FollowerState {
  final List<FollowerUser> followers;

  FollowersLoaded(this.followers);
}

class FollowingLoaded extends FollowerState {
  final List<FollowerUser> following;

  FollowingLoaded(this.following);
}

class FollowerError extends FollowerState {
  final String message;

  FollowerError(this.message);
}
