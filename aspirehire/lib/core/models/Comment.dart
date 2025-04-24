// --- Create Comment ---
class CreateCommentRequest {
  String? content;
  String? attachment; // File path or URL for form-data

  Map<String, dynamic> toJson() => {
        if (content != null) 'content': content,
        if (attachment != null) 'attachment': attachment,
      };
}

class CreateCommentResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "comment": { "id": string, "content": string, "attachment": string|null, "user": { "id": string, "name": string, ... }, "createdAt": string, "reacts": [] } }

  CreateCommentResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateCommentResponse.fromJson(Map<String, dynamic> json) =>
      CreateCommentResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Update Comment ---
class UpdateCommentRequest {
  String? content;
  String? attachment; // File path or URL for form-data

  Map<String, dynamic> toJson() => {
        if (content != null) 'content': content,
        if (attachment != null) 'attachment': attachment,
      };
}

class UpdateCommentResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "comment": { "id": string, "content": string, ... } }

  UpdateCommentResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateCommentResponse.fromJson(Map<String, dynamic> json) =>
      UpdateCommentResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Get All Comments ---
class GetCommentsRequest {
  // No body needed; postId is in the URL
  Map<String, dynamic> toJson() => {};
}

class GetCommentsResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "comments": [{ "id": string, "content": string, ... }, ...] }

  GetCommentsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetCommentsResponse.fromJson(Map<String, dynamic> json) =>
      GetCommentsResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Like or Dislike Comment ---
class LikeCommentRequest {
  String? react; // e.g., "Love", "Like"

  Map<String, dynamic> toJson() => {
        if (react != null) 'react': react,
      };
}

class LikeCommentResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  LikeCommentResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LikeCommentResponse.fromJson(Map<String, dynamic> json) =>
      LikeCommentResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// --- Get All Likes of Comment ---
class GetCommentLikesRequest {
  // No body needed; postId and commentId are in the URL
  Map<String, dynamic> toJson() => {};
}

class GetCommentLikesResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data; // Expected: { "reacts": [{ "id": string, "type": string, "user": { "id": string, "name": string, ... } }, ...] }

  GetCommentLikesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetCommentLikesResponse.fromJson(Map<String, dynamic> json) =>
      GetCommentLikesResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}