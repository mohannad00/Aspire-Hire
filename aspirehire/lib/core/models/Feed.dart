// Root response model for GET /feed
class FeedResponse {
  final bool success;
  final List<FeedPostEntry> data;

  FeedResponse({required this.success, required this.data});

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 [FeedResponse] Parsing JSON: $json');
    try {
      final success = json['success'] ?? false;
      print('🔍 [FeedResponse] Success: $success');

      final dataList = json['data'] as List<dynamic>?;
      print('🔍 [FeedResponse] Data list type: ${dataList.runtimeType}');
      print('🔍 [FeedResponse] Data list length: ${dataList?.length ?? 0}');

      final data =
          dataList?.map((item) {
            print('🔍 [FeedResponse] Parsing item: $item');
            return FeedPostEntry.fromJson(item as Map<String, dynamic>);
          }).toList() ??
          [];

      print('🔍 [FeedResponse] Parsed ${data.length} posts successfully');
      return FeedResponse(success: success, data: data);
    } catch (e, stackTrace) {
      print('🔍 [FeedResponse] Error parsing JSON: $e');
      print('🔍 [FeedResponse] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.map((entry) => entry.toJson()).toList(),
  };
}

// Represents a single post entry in the feed with a score
class FeedPostEntry {
  final Post post;
  final double? score;

  FeedPostEntry({required this.post, this.score});

  factory FeedPostEntry.fromJson(Map<String, dynamic> json) {
    print('🔍 [FeedPostEntry] Parsing entry: $json');
    try {
      final post = Post.fromJson(json['post'] as Map<String, dynamic>);
      final score = (json['score'] as num?)?.toDouble();
      print('🔍 [FeedPostEntry] Parsed post with ID: ${post.id}');
      return FeedPostEntry(post: post, score: score);
    } catch (e, stackTrace) {
      print('🔍 [FeedPostEntry] Error parsing entry: $e');
      print('🔍 [FeedPostEntry] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'post': post.toJson(),
    if (score != null) 'score': score,
  };
}

// Post model (recursive for sharedFrom)
class Post {
  String? id;
  String? content;
  List<String>? tags;
  List<Attachment>? attachments;
  Post? sharedFrom;
  int? shareCount;
  String? publisherId;
  bool? archived;
  String? createdAt;
  String? updatedAt;
  List<Publisher>? publisher;
  List<React>? reacts;
  List<Comment>? comments;

  Post({
    this.id,
    this.content,
    this.tags,
    this.attachments,
    this.sharedFrom,
    this.shareCount,
    this.publisherId,
    this.archived,
    this.createdAt,
    this.updatedAt,
    this.publisher,
    this.reacts,
    this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['_id'] as String?,
    content: json['content'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
    attachments:
        (json['attachments'] as List<dynamic>?)
            ?.map((item) => Attachment.fromJson(item as Map<String, dynamic>))
            .toList(),
    sharedFrom:
        json['sharedFrom'] != null
            ? Post.fromJson(json['sharedFrom'] as Map<String, dynamic>)
            : null,
    shareCount: json['shareCount'] as int?,
    publisherId: json['publisherId'] as String?,
    archived: json['archived'] as bool?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    publisher:
        (json['publisher'] as List<dynamic>?)
            ?.map((item) => Publisher.fromJson(item as Map<String, dynamic>))
            .toList(),
    reacts:
        (json['reacts'] as List<dynamic>?)
            ?.map((item) => React.fromJson(item as Map<String, dynamic>))
            .toList(),
    comments:
        (json['comments'] as List<dynamic>?)
            ?.map((item) => Comment.fromJson(item as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (content != null) 'content': content,
    if (tags != null) 'tags': tags,
    if (attachments != null)
      'attachments': attachments!.map((item) => item.toJson()).toList(),
    if (sharedFrom != null) 'sharedFrom': sharedFrom!.toJson(),
    if (shareCount != null) 'shareCount': shareCount,
    if (publisherId != null) 'publisherId': publisherId,
    if (archived != null) 'archived': archived,
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
    if (publisher != null)
      'publisher': publisher!.map((item) => item.toJson()).toList(),
    if (reacts != null) 'reacts': reacts!.map((item) => item.toJson()).toList(),
    if (comments != null)
      'comments': comments!.map((item) => item.toJson()).toList(),
  };
}

// Attachment model
class Attachment {
  String? secureUrl;
  String? publicId;
  String? id;

  Attachment({this.secureUrl, this.publicId, this.id});

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    secureUrl: json['secure_url'] as String?,
    publicId: json['public_id'] as String?,
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() => {
    if (secureUrl != null) 'secure_url': secureUrl,
    if (publicId != null) 'public_id': publicId,
    if (id != null) '_id': id,
  };
}

// Publisher model
class Publisher {
  String? profileId;
  String? username;
  ProfilePicture? profilePicture;
  String? firstName;
  String? lastName;
  String? companyName;

  Publisher({
    this.profileId,
    this.username,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.companyName,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) => Publisher(
    profileId: json['profileId'] as String?,
    username: json['username'] as String?,
    profilePicture:
        json['profilePicture'] != null
            ? ProfilePicture.fromJson(
              json['profilePicture'] as Map<String, dynamic>,
            )
            : null,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    companyName: json['companyName'] as String?,
  );

  Map<String, dynamic> toJson() => {
    if (profileId != null) 'profileId': profileId,
    if (username != null) 'username': username,
    if (profilePicture != null) 'profilePicture': profilePicture!.toJson(),
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (companyName != null) 'companyName': companyName,
  };
}

// ProfilePicture model
class ProfilePicture {
  String? secureUrl;

  ProfilePicture({this.secureUrl});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) =>
      ProfilePicture(secureUrl: json['secure_url'] as String?);

  Map<String, dynamic> toJson() => {
    if (secureUrl != null) 'secure_url': secureUrl,
  };
}

// React model
class React {
  String? id;
  String? userId;
  String? entityId;
  String? entityType;
  String? react;
  String? createdAt;
  String? updatedAt;
  List<Publisher>? user;

  React({
    this.id,
    this.userId,
    this.entityId,
    this.entityType,
    this.react,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory React.fromJson(Map<String, dynamic> json) => React(
    id: json['_id'] as String?,
    userId: json['userId'] as String?,
    entityId: json['entityId'] as String?,
    entityType: json['entityType'] as String?,
    react: json['react'] as String?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    user:
        (json['user'] as List<dynamic>?)
            ?.map((item) => Publisher.fromJson(item as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (userId != null) 'userId': userId,
    if (entityId != null) 'entityId': entityId,
    if (entityType != null) 'entityType': entityType,
    if (react != null) 'react': react,
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
    if (user != null) 'user': user!.map((item) => item.toJson()).toList(),
  };
}

// Comment model
class Comment {
  String? id;
  String? postId;
  String? content;
  Attachment? attachment;
  List<Publisher>? user;
  String? createdAt;
  String? updatedAt;

  Comment({
    this.id,
    this.postId,
    this.content,
    this.attachment,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['_id'] as String?,
    postId: json['postId'] as String?,
    content: json['content'] as String?,
    attachment:
        json['attachment'] != null
            ? Attachment.fromJson(json['attachment'] as Map<String, dynamic>)
            : null,
    user:
        (json['user'] as List<dynamic>?)
            ?.map((item) => Publisher.fromJson(item as Map<String, dynamic>))
            .toList(),
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (postId != null) 'postId': postId,
    if (content != null) 'content': content,
    if (attachment != null) 'attachment': attachment!.toJson(),
    if (user != null) 'user': user!.map((item) => item.toJson()).toList(),
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
  };
}
