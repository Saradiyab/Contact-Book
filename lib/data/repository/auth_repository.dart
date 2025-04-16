import 'package:contact_app1/data/api/auth_servic.dart';
import 'package:contact_app1/data/models/Register.dart';
import 'package:contact_app1/data/models/auth.dart';
import 'package:contact_app1/data/models/login.dart';


abstract class IAuthRepository {
  Future<AuthResponse?> login(LoginRequest loginRequest);
  Future<AuthResponse?> register(RegisterRequest registerRequest);
  Future<void> logout();
  Future<String?> getToken();
  Future<void> checkToken();
}

class AuthRepository implements IAuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  @override
  Future<AuthResponse?> login(LoginRequest loginRequest) async {
    try {
      final response = await authService.login(loginRequest);
      if (response == null || response.token.isEmpty) {
        throw Exception("Login failed. Response is invalid.");
      }
      return response;
    } catch (e) {
      print("AuthRepository →Login Error: $e");
      return AuthResponse(token: "", message: "Login failed. Please try again.");
    }
  }

  @override
  Future<AuthResponse?> register(RegisterRequest registerRequest) async {
    try {
      final response = await authService.register(registerRequest);
      if (response == null || response.token.isEmpty) {
        throw Exception("Registration failed. Response is invalid.");
      }
      return response;
    } catch (e) {
      print("AuthRepository → Register Error: $e");
      return AuthResponse(token: "", message: "Registration failed. Please try again..");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authService.logout();
      print("User logged out successfully.");
    } catch (e) {
      print("AuthRepository → Logout Error: $e");
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await authService.getToken();
    } catch (e) {
      print("AuthRepository → Token Retrieval Error: $e");
      return null;
    }
  }

  @override
  Future<void> checkToken() async {
    try {
      await authService.checkToken();
    } catch (e) {
      print("AuthRepository → Token Check Error: $e");
    }
  }
}
