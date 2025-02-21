class EmployeeRegistrationRequest {
  String? email;
  String? password;
  String? phone;
  String? username;
  String? firstName;
  String? lastName;
  String? dob;
  String? gender;
  // Add other attributes as needed

  Map<String, dynamic> toJson() => {
    if (email != null) 'email': email,
    if (password != null) 'password': password,
    if (phone != null) 'phone': phone,
    if (username != null) 'username': username,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (dob != null) 'dob': dob,
    if (gender != null) 'gender': gender,
    // Add other attributes as needed
  };
}

class EmployeeRegistrationResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  EmployeeRegistrationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EmployeeRegistrationResponse.fromJson(Map<String, dynamic> json) => EmployeeRegistrationResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"],
  );
}