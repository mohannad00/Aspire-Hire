import '../../core/models/Company.dart';

abstract class CompanyProfileState {}

class CompanyProfileInitial extends CompanyProfileState {}

class CompanyProfileLoading extends CompanyProfileState {}

class CompanyProfileLoaded extends CompanyProfileState {
  final CompanyProfileData data;
  CompanyProfileLoaded(this.data);
}

class CompanyProfileError extends CompanyProfileState {
  final String message;
  CompanyProfileError(this.message);
}
