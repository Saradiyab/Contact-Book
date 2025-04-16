class AuthResponse {
  final String token;
  final String? message; 

  AuthResponse({required this.token, this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
  return AuthResponse(
    token: json["token"] ?? json["access_token"] ?? "", 
    message: json["message"] ?? "Login successful",
  );
 }
}
