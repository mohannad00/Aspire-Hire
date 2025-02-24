class DeleteProfilePictureResponse {
  final String message;

  DeleteProfilePictureResponse({required this.message});

  factory DeleteProfilePictureResponse.fromJson(Map<String, dynamic> json) {
    return DeleteProfilePictureResponse(
      message: json['message'],
    );
  }
}
