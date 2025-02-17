class RequestPasswordResetRequest {
  final String email;

  RequestPasswordResetRequest({required this.email});

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}

class RequestPasswordResetResponse {
  final bool success;
  final String message;

  RequestPasswordResetResponse({
    required this.success,
    required this.message,
  });

  factory RequestPasswordResetResponse.fromJson(Map<String, dynamic> json) => RequestPasswordResetResponse(
    success: json['success'],
    message: json['message'],
  );
}

class PasswordResetRequest {
  final String newPassword;

  PasswordResetRequest({required this.newPassword});

  Map<String, dynamic> toJson() => {
    'newPassword': newPassword,
  };
}

class PasswordResetResponse {
  final bool success;
  final String message;

  PasswordResetResponse({
    required this.success,
    required this.message,
  });

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) => PasswordResetResponse(
    success: json['success'],
    message: json['message'],
  );
}