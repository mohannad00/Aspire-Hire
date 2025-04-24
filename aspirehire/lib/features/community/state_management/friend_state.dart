import '../../../core/models/Friend.dart';

abstract class FriendState {}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendRequestSent extends FriendState {
  final String message;

  FriendRequestSent(this.message);
}

class FriendRequestApproved extends FriendState {
  final String message;

  FriendRequestApproved(this.message);
}

class FriendUnfriended extends FriendState {
  final String message;

  FriendUnfriended(this.message);
}

class FriendsLoaded extends FriendState {
  final List<User> friends;

  FriendsLoaded(this.friends);
}

class FriendRequestsLoaded extends FriendState {
  final List<FriendRequest> requests;

  FriendRequestsLoaded(this.requests);
}

class FriendError extends FriendState {
  final String message;

  FriendError(this.message);
}