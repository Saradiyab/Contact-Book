import '../../domain/entities/auth_response.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.token,
    super.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json["token"] ?? json["access_token"] ?? "",
      message: json["message"] ?? "Login successful",
    );
  }
}
