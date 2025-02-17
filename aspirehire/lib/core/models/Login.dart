class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "email": username,
    "password": password,
  };
}

class LoginResponse {
  final bool success;
  final String message;
  final String token;

  LoginResponse({
    required this.success,
    required this.message,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"],
    message: json["message"],
    token: json["token"],
  );
}