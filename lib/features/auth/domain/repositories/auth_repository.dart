import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/auth/domain/entities/auth_response.dart';
import 'package:contact_app1/features/auth/domain/entities/login_credentials.dart';
import 'package:contact_app1/features/auth/domain/entities/register_info.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login(LoginCredentials credentials);
  Future<Either<Failure, AuthResponse>> register(RegisterInfo info);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, void>> checkToken();
}
