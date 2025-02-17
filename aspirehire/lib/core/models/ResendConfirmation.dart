class ResendConfirmRequest {
  final String email;

  ResendConfirmRequest({required this.email});

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}

class ResendConfirmResponse {
  final bool success;
  final String message;

  ResendConfirmResponse({
    required this.success,
    required this.message,
  });

  factory ResendConfirmResponse.fromJson(Map<String, dynamic> json) => ResendConfirmResponse(
    success: json['success'],
    message: json['message'],
  );
}