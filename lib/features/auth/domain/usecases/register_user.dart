import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/auth/domain/entities/auth_response.dart';
import 'package:contact_app1/features/auth/domain/entities/register_info.dart';
import 'package:contact_app1/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, AuthResponse>> call(RegisterInfo info) async{
    return repository.register(info);
  }
}
