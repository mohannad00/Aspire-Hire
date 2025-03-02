class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'http://hiro.eu-4.evennode.com';
  static const String localhost = 'http://localhost:3000';

  // Auth Endpoints
  static const String employeeRegister = '$baseUrl/auth/employee';
  static const String jobseekerRegister = '$baseUrl/auth/employee';
  static const String companyRegister = '$baseUrl/auth/company';
  static const String login = '$baseUrl/auth/login';
  static const String resendConfirm = '$baseUrl/auth/resend-confirm';
  static const String requestPasswordReset = '$baseUrl/auth/request-password-reset';
  static const String passwordReset = '$baseUrl/auth/password-reset';

  // Profile Endpoints
  static const String getProfile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile';
  static const String updateProfilePicture = '$baseUrl/profile/profile-picture';
  static const String uploadResume = '$baseUrl/profile/resume';
  static const String deleteProfilePicture = '$baseUrl/profile/profile-picture';

  // Job Post Endpoints
  static const String createJobPost = '$baseUrl/jobpost';
  static const String updateJobPost = '$baseUrl/jobpost'; // Append /:jobPostId
  static const String deleteJobPost = '$baseUrl/jobpost'; // Append /:jobPostId
  static const String getJobPost = '$baseUrl/jobpost'; // Append ?id=:jobPostId
  static const String searchJobPosts = '$baseUrl/jobpost/search';

  // Job Application Endpoints
  static const String createJobApplication = '$baseUrl/jobpost/:jobPostId/application';
  static const String updateJobApplication = '$baseUrl/jobpost/:jobPostId/application/:applicationId';
  static const String getJobApplication = '$baseUrl/jobpost/:jobPostId/application/:applicationId';
  static const String getJobApplications = '$baseUrl/jobpost/:jobPostId/application';
}