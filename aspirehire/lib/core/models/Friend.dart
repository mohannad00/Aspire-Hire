// User model for friend and requester data
class User {
  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? profilePictureUrl;

  User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String?,
    username: json['username'] as String?,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    profilePictureUrl: json['profilePicture']?['secure_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (username != null) 'username': username,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (profilePictureUrl != null)
      'profilePicture': {'secure_url': profilePictureUrl},
  };
}

// FriendRequest model for friend requests
class FriendRequest {
  String? id;
  User? requester;
  String? createdAt;

  FriendRequest({this.id, this.requester, this.createdAt});

  factory FriendRequest.fromJson(Map<String, dynamic> json) => FriendRequest(
    id: json['profileId'] as String?, // Changed from 'id' to 'profileId'
    requester:
        json != null
            ? User(
              id: json['profileId'] as String?,
              username: json['username'] as String?,
              firstName: json['firstName'] as String?,
              lastName: json['lastName'] as String?,
              profilePictureUrl:
                  json['profilePicture']?['secure_url'] as String?,
            )
            : null,
    createdAt: json['createdAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'profileId': id,
    if (requester != null)
      'requester': {
        'profileId': requester!.id,
        'username': requester!.username,
        'firstName': requester!.firstName,
        'lastName': requester!.lastName,
        'profilePicture':
            requester!.profilePictureUrl != null
                ? {'secure_url': requester!.profilePictureUrl}
                : null,
      },
    if (createdAt != null) 'createdAt': createdAt,
  };
}

// Send or Cancel Friend Request
class SendFriendRequest {
  Map<String, dynamic> toJson() => {};
}

class SendFriendResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  SendFriendResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SendFriendResponse.fromJson(Map<String, dynamic> json) =>
      SendFriendResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// Approve or Decline Friend Request
class ApproveFriendRequest {
  bool? action;

  Map<String, dynamic> toJson() => {if (action != null) 'action': action};
}

class ApproveFriendResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  ApproveFriendResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApproveFriendResponse.fromJson(Map<String, dynamic> json) =>
      ApproveFriendResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// Unfriend User
class UnfriendRequest {
  Map<String, dynamic> toJson() => {};
}

class UnfriendResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  UnfriendResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UnfriendResponse.fromJson(Map<String, dynamic> json) =>
      UnfriendResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}

// Insert a new Friend class above GetFriendsRequest
class Friend {
  final Map<String, dynamic> profilePicture; // (secure_url, public_id)
  final String profileId;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? id;

  Friend({
    required this.profilePicture,
    required this.profileId,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.id,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      profilePicture: json["profilePicture"] ?? {},
      profileId: json["profileId"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profilePicture": profilePicture,
      "profileId": profileId,
      "username": username,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "id": id,
    };
  }
}

// Existing GetFriendsRequest (no change if not needed)
class GetFriendsRequest {
  Map<String, dynamic> toJson() => {};
}

// Update GetFriendsResponse to use a List<Friend> for data
class GetFriendsResponse {
  final bool success;
  final String message;
  final List<Friend> data;

  GetFriendsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetFriendsResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json["data"] ?? [];
    List<Friend> friends =
        dataList.map((item) => Friend.fromJson(item)).toList();
    return GetFriendsResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: friends,
    );
  }
}

// Get All Friend Requests
class GetFriendRequestsRequest {
  Map<String, dynamic> toJson() => {};
}

class GetFriendRequestsResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  GetFriendRequestsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetFriendRequestsResponse.fromJson(Map<String, dynamic> json) =>
      GetFriendRequestsResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? {},
      );
}
