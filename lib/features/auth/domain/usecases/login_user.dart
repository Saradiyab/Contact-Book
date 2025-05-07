import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/auth/domain/entities/auth_response.dart';
import 'package:contact_app1/features/auth/domain/entities/login_credentials.dart';
import 'package:contact_app1/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, AuthResponse>> call(LoginCredentials credentials)async {
    return repository.login(credentials);
  }
}
