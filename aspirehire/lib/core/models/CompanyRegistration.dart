class CompanyRegistrationRequest {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String companyName;
  final String address;

  CompanyRegistrationRequest({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.companyName,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "phone": phone,
    "password": password,
    "companyName": companyName,
    "address": address,
  };
}

class CompanyRegistrationResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  CompanyRegistrationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CompanyRegistrationResponse.fromJson(Map<String, dynamic> json) => CompanyRegistrationResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"],
  );
}