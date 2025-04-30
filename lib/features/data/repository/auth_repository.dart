import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/data/api/auth_servic.dart';
import 'package:contact_app1/features/data/models/auth.dart';
import 'package:contact_app1/features/data/models/login.dart';
import 'package:contact_app1/features/data/models/register.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

final logger = Logger();

abstract class IAuthRepository {
  Future<Either<Failure, AuthResponse>> login(LoginRequest loginRequest);
  Future<Either<Failure, AuthResponse>> register(RegisterRequest registerRequest);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, void>> checkToken();
}

class AuthRepository implements IAuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest loginRequest) async {
    try {
      final response = await authService.login(loginRequest);
      if (response == null || response.token.isEmpty) {
        return Left(ServerFailure(AppStrings.loginInvalidResponse));
      }
      return Right(response);
    } catch (e) {
      logger.e("AuthRepository → Login Error", error: e);
      return Left(NetworkFailure(AppStrings.loginFailed));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(RegisterRequest registerRequest) async {
    try {
      final response = await authService.register(registerRequest);
      if (response == null || response.token.isEmpty) {
        return Left(ServerFailure(AppStrings.registrationInvalidResponse));
      }
      return Right(response);
    } catch (e) {
      logger.e("AuthRepository → Register Error", error: e);
      return Left(NetworkFailure(AppStrings.registrationFailed));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authService.logout();
      logger.i(AppStrings.logoutSuccess);
      return const Right(null);
    } catch (e) {
      logger.e("AuthRepository → Logout Error", error: e);
      return Left(NetworkFailure(AppStrings.logoutFailed));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await authService.getToken();
      return Right(token);
    } catch (e) {
      logger.e("AuthRepository → Token Retrieval Error", error: e);
      return Left(NetworkFailure(AppStrings.tokenCheckFailed));
    }
  }

  @override
  Future<Either<Failure, void>> checkToken() async {
    try {
      await authService.checkToken();
      return const Right(null);
    } catch (e) {
      logger.e("AuthRepository → Token Check Error", error: e);
      return Left(NetworkFailure(AppStrings.tokenCheckFailed));
    }
  }
}
