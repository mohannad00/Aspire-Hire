import '../../../core/models/GetProfile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);
}

class ProfileUpdated extends ProfileState {
  final Profile profile;

  ProfileUpdated(this.profile);
}

class ProfilePictureUpdated extends ProfileState {
  final Profile profile;

  ProfilePictureUpdated(this.profile);
}

class ResumeUploaded extends ProfileState {
  final Profile profile;

  ResumeUploaded(this.profile);
}

class ProfilePictureDeleted extends ProfileState {
  final String message;

  ProfilePictureDeleted(this.message);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}