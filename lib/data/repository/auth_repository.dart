import 'package:contact_app1/core/constants/strings.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/data/api/auth_servic.dart';
import 'package:contact_app1/data/models/register.dart';
import 'package:contact_app1/data/models/auth.dart';
import 'package:contact_app1/data/models/login.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

final logger = Logger();

abstract class IAuthRepository {
  Future<Either<Failure, AuthResponse>> login(LoginRequest loginRequest);
  Future<Either<Failure, AuthResponse>> register(RegisterRequest registerRequest);
  Future<void> logout();
  Future<String?> getToken(); // token hala burada
  Future<void> checkToken();
}

class AuthRepository implements IAuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest loginRequest) async {
    try {
      final response = await authService.login(loginRequest);
      if (response == null || response.token.isEmpty) {
        return Left(ServerFailure(MessageStrings.loginInvalidResponse));
      }
      return Right(response);
    } catch (e) {
      logger.e("AuthRepository → Login Error", error: e);
      return Left(NetworkFailure(MessageStrings.loginFailed));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(RegisterRequest registerRequest) async {
    try {
      final response = await authService.register(registerRequest);
      if (response == null || response.token.isEmpty) {
        return Left(ServerFailure(MessageStrings.registrationInvalidResponse));
      }
      return Right(response); // token hala AuthResponse içinde dönüyor
    } catch (e) {
      logger.e("AuthRepository → Register Error", error: e);
      return Left(NetworkFailure(MessageStrings.registrationFailed));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authService.logout();
      logger.i(MessageStrings.logoutSuccess);
    } catch (e) {
      logger.e("AuthRepository → Logout Error", error: e);
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await authService.getToken(); // token hala burada
    } catch (e) {
      logger.e("AuthRepository → Token Retrieval Error", error: e);
      return null;
    }
  }

  @override
  Future<void> checkToken() async {
    try {
      await authService.checkToken();
    } catch (e) {
      logger.e("AuthRepository → Token Check Error", error: e);
    }
  }
}
