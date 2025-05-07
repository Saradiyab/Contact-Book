class AuthResponse {
  final String token;
  final String? message;

  const AuthResponse({
    required this.token,
    this.message,
  });
}
