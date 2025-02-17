import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Map<String, dynamic> profileData;

  const ProfileSuccess(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}