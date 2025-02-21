class CompanyRegistrationRequest {
  String? email;
  String? password;
  String? phone;
  String? username;
  String? companyName;
  String? address;
  // Add other attributes as needed

  Map<String, dynamic> toJson() => {
    if (email != null) 'email': email,
    if (password != null) 'password': password,
    if (phone != null) 'phone': phone,
    if (username != null) 'username': username,
    if (companyName != null) 'companyName': companyName,
    if (address != null) 'address': address,
    // Add other attributes as needed
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