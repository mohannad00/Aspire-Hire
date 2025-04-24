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

// --- Get All Followers ---
class GetFollowersRequest {
  // No body needed for GET
  Map<String, dynamic> toJson() => {};
}

class GetFollowersResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "followers": [{ "id": string, "name": string, ... }, ...] }

  GetFollowersResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetFollowersResponse.fromJson(Map<String, dynamic> json) =>
      GetFollowersResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Get All Following ---
class GetFollowingRequest {
  // No body needed for GET
  Map<String, dynamic> toJson() => {};
}

class GetFollowingResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "following": [{ "id": string, "name": string, ... }, ...] }

  GetFollowingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetFollowingResponse.fromJson(Map<String, dynamic> json) =>
      GetFollowingResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}