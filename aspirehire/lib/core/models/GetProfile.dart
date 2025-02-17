class ProfileResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  ProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"],
  );
}