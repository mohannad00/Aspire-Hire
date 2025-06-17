import '../../../core/models/UserProfile.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileData data;

  UserProfileLoaded(this.data);
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError(this.message);
}
