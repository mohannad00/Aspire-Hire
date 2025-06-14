class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://2203-156-199-119-181.ngrok-free.app';
  static const String localhost = 'http://localhost:3000';
  // todo https://hiro-neon.vercel.app
  // todo http://10.0.2.2:3000
  // Auth Endpoints
  static const String employeeRegister = '$baseUrl/auth/employee';
  static const String jobseekerRegister = '$baseUrl/auth/employee';
  static const String companyRegister = '$baseUrl/auth/company';
  static const String login = '$baseUrl/auth/login';
  static const String resendConfirm = '$baseUrl/auth/resend-confirm';
  static const String requestPasswordReset =
      '$baseUrl/auth/request-password-reset';
  static const String passwordReset = '$baseUrl/auth/password-reset';

  // Profile Endpoints
  static const String getProfile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile';
  static const String updateProfilePicture = '$baseUrl/profile/profile-picture';
  static const String uploadResume = '$baseUrl/profile/resume';
  static const String deleteProfilePicture = '$baseUrl/profile/profile-picture';
  static const String searchUsers = '$baseUrl/profile/search/?q:query';
  static const String updateSkills = '$baseUrl/profile/skills';

  // Skill Test Endpoints
  static const String getQuiz = '$baseUrl/skill/quiz';
  static const String submitQuiz = '$baseUrl/skill/quiz';

  // Job Post Endpoints
  static const String createJobPost = '$baseUrl/jobpost';
  static const String updateJobPost =
      '$baseUrl/jobpost'; // Todo Append /:jobPostId
  static const String deleteJobPost =
      '$baseUrl/jobpost'; // Todo Append /:jobPostId
  static const String getJobPost =
      '$baseUrl/jobpost'; //  Todo Append ?id=:jobPostId
  static const String searchJobPosts = '$baseUrl/jobpost/search';
  static const String getRecommendedJobPosts = '$baseUrl/jobpost/recommended';

  // Job Application Endpoints
  static const String createJobApplication =
      '$baseUrl/jobpost/:jobPostId/application';
  static const String updateJobApplication =
      '$baseUrl/jobpost/:jobPostId/application/:applicationId';
  static const String getJobApplication =
      '$baseUrl/jobpost/:jobPostId/application/:applicationId';
  static const String getJobApplications =
      '$baseUrl/jobpost/:jobPostId/application';

  // Community - Friend Endpoints
  static const String sendOrCancelFriendRequest =
      '$baseUrl/friend/:userId/request';
  static const String approveOrDeclineFriendRequest =
      '$baseUrl/friend/:userId/request';
  static const String unfriendUser = '$baseUrl/friend/:userId';
  static const String getAllFriends = '$baseUrl/friend';
  static const String getAllFriendRequests = '$baseUrl/friend/requests';

  // Community - Follower Endpoints
  static const String followOrUnfollowUser = '$baseUrl/follow/:userId';
  static const String getAllFollowers = '$baseUrl/follow';
  static const String getAllFollowing = '$baseUrl/follow/following';

  // Community - Post Endpoints
  static const String createPost = '$baseUrl/post';
  static const String getPost = '$baseUrl/post/:postId';
  static const String getAllLikesOfPost = '$baseUrl/post/:postId/reacts';
  static const String getArchivedPosts = '$baseUrl/post/archived';
  static const String deletePost = '$baseUrl/post/:postId';
  static const String archivePost = '$baseUrl/post/:postId';
  static const String updatePost = '$baseUrl/post/:postId';
  static const String likeOrDislikePost = '$baseUrl/post/:postId';

  // Community - Comment Endpoints
  static const String createComment = '$baseUrl/post/:postId/comment';
  static const String updateComment =
      '$baseUrl/post/:postId/comment/:commentId';
  static const String getAllComments = '$baseUrl/post/:postId/comment';
  static const String likeOrDislikeComment =
      '$baseUrl/post/:postId/comment/:commentId';
  static const String getAllLikesOfComment =
      '$baseUrl/post/:postId/comment/:commentId/reacts';

  // Community - Feed Endpoints
  static const String getFeedPosts = '$baseUrl/feed';
}
