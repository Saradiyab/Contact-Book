import '../../domain/entities/login_credentials.dart';

class LoginRequestModel extends LoginCredentials {
  LoginRequestModel({
    required super.email,
    required super.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'],
      password: json['password'],
    );
  }
}
