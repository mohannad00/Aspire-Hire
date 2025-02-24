class UpdateProfileRequest {
  final String email;

  UpdateProfileRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}