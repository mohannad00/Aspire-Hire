part of 'company_job_posts_cubit.dart';

abstract class CompanyJobPostsState extends Equatable {
  const CompanyJobPostsState();

  @override
  List<Object> get props => [];
}

class CompanyJobPostsInitial extends CompanyJobPostsState {}

class CompanyJobPostsLoading extends CompanyJobPostsState {}

class CompanyJobPostsSuccess extends CompanyJobPostsState {
  final List<JobPostData> jobPosts;

  const CompanyJobPostsSuccess(this.jobPosts);

  @override
  List<Object> get props => [jobPosts];
}

class CompanyJobPostsFailure extends CompanyJobPostsState {
  final String message;

  const CompanyJobPostsFailure(this.message);

  @override
  List<Object> get props => [message];
} 