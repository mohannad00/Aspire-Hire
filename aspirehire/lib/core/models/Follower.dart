// --- Follow or Unfollow User ---
class FollowRequest {
  // No body needed; userId is in the URL
  Map<String, dynamic> toJson() => {};
}

class FollowResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  FollowResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FollowResponse.fromJson(Map<String, dynamic> json) => FollowResponse(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: json['data'] ?? {},
  );
}

// User model for follower and following data
class FollowerUser {
  final String profileId;
  final String username;
  final ProfilePicture? profilePicture;
  final String firstName;
  final String lastName;

  FollowerUser({
    required this.profileId,
    required this.username,
    this.profilePicture,
    required this.firstName,
    required this.lastName,
  });

  factory FollowerUser.fromJson(Map<String, dynamic> json) => FollowerUser(
    profileId: json['profileId'] as String,
    username: json['username'] as String,
    profilePicture:
        json['profilePicture'] != null
            ? ProfilePicture.fromJson(
              json['profilePicture'] as Map<String, dynamic>,
            )
            : null,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
  );

  Map<String, dynamic> toJson() => {
    'profileId': profileId,
    'username': username,
    if (profilePicture != null) 'profilePicture': profilePicture!.toJson(),
    'firstName': firstName,
    'lastName': lastName,
  };
}

class ProfilePicture {
  final String secureUrl;

  ProfilePicture({required this.secureUrl});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) =>
      ProfilePicture(secureUrl: json['secure_url'] as String);

  Map<String, dynamic> toJson() => {'secure_url': secureUrl};
}

// --- Get All Followers ---
class GetFollowersRequest {
  // No body needed for GET
  Map<String, dynamic> toJson() => {};
}

class GetFollowersResponse {
  final bool success;
  final String message;
  final List<FollowerUser> data;

  GetFollowersResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetFollowersResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'] ?? [];
    List<FollowerUser> followers =
        dataList
            .map((item) => FollowerUser.fromJson(item as Map<String, dynamic>))
            .toList();
    return GetFollowersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: followers,
    );
  }
}

// --- Get All Following ---
class GetFollowingRequest {
  // No body needed for GET
  Map<String, dynamic> toJson() => {};
}

class GetFollowingResponse {
  final bool success;
  final String message;
  final List<FollowerUser> data;

  GetFollowingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetFollowingResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'] ?? [];
    List<FollowerUser> following =
        dataList
            .map((item) => FollowerUser.fromJson(item as Map<String, dynamic>))
            .toList();
    return GetFollowingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: following,
    );
  }
}
