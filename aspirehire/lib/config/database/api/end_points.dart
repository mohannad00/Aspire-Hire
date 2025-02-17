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
  static const String requestPasswordReset =
      '$baseUrl/auth/request-password-reset';
  static const String passwordReset = '$baseUrl/auth/password-reset';

  // Job Post Endpoints
  static const String createJobPost =
      '$baseUrl/jobpost'; 

  static const String updateJobPost = '$baseUrl/jobpost'; // Append /:jobPostId
  static const String deleteJobPost = '$baseUrl/jobpost'; // Append /:jobPostId
  static const String getJobPost = '$baseUrl/jobpost'; // Append ?id=:jobPostId
  static const String searchJobPosts = '$baseUrl/jobpost/search';

  // Employee Endpoints
  static const String getEmployeeProfile = '$baseUrl/employee/profile';
  static const String updateEmployeeProfile = '$baseUrl/employee/profile';

  // Company Endpoints
  static const String getCompanyProfile = '$baseUrl/company/profile';
  static const String updateCompanyProfile = '$baseUrl/company/profile';

  
}
