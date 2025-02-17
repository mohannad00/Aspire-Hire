class EmployeeRegistrationRequest {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;

  EmployeeRegistrationRequest({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "phone": phone,
    "password": password,
    "firstName": firstName,
    "lastName": lastName,
    "dob": dob,
    "gender": gender,
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