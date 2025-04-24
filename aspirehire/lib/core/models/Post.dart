// --- Create Post ---
class CreatePostRequest {
  String? content;
  String? attachment; // File path or URL for form-data

  Map<String, dynamic> toJson() => {
        if (content != null) 'content': content,
        if (attachment != null) 'attachment': attachment,
      };
}

class CreatePostResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "post": { "id": string, "content": string, "attachment": string|null, "user": { "id": string, "name": string, ... }, "createdAt": string, "reacts": [], "isArchived": bool } }

  CreatePostResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) =>
      CreatePostResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Get Post ---
class GetPostRequest {
  // No body needed; postId is in the URL
  Map<String, dynamic> toJson() => {};
}

class GetPostResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "post": { "id": string, "content": string, ... } }

  GetPostResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetPostResponse.fromJson(Map<String, dynamic> json) =>
      GetPostResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Get All Likes of Post ---
class GetPostLikesRequest {
  // No body needed; postId is in the URL
  Map<String, dynamic> toJson() => {};
}

class GetPostLikesResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "reacts": [{ "id": string, "type": string, "user": { "id": string, "name": string, ... } }, ...] }

  GetPostLikesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetPostLikesResponse.fromJson(Map<String, dynamic> json) =>
      GetPostLikesResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Get Archived Posts ---
class GetArchivedPostsRequest {
  // No body needed for GET
  Map<String, dynamic> toJson() => {};
}

class GetArchivedPostsResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "posts": [{ "id": string, "content": string, ... }, ...] }

  GetArchivedPostsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetArchivedPostsResponse.fromJson(Map<String, dynamic> json) =>
      GetArchivedPostsResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Delete Post ---
class DeletePostRequest {
  // No body needed; postId is in the URL
  Map<String, dynamic> toJson() => {};
}

class DeletePostResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  DeletePostResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DeletePostResponse.fromJson(Map<String, dynamic> json) =>
      DeletePostResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Archive Post ---
class ArchivePostRequest {
  // No body needed; postId is in the URL
  Map<String, dynamic> toJson() => {};
}

class ArchivePostResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  ArchivePostResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ArchivePostResponse.fromJson(Map<String, dynamic> json) =>
      ArchivePostResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Update Post ---
class UpdatePostRequest {
  String? content;
  String? attachment; // File path or URL for form-data

  Map<String, dynamic> toJson() => {
        if (content != null) 'content': content,
        if (attachment != null) 'attachment': attachment,
      };
}

class UpdatePostResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "post": { "id": string, "content": string, ... } }

  UpdatePostResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdatePostResponse.fromJson(Map<String, dynamic> json) =>
      UpdatePostResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Like or Dislike Post ---
class LikePostRequest {
  String? react; // e.g., "Love", "Like"

  Map<String, dynamic> toJson() => {
        if (react != null) 'react': react,
      };
}

class LikePostResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  LikePostResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LikePostResponse.fromJson(Map<String, dynamic> json) =>
      LikePostResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}