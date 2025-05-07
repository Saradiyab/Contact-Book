import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/auth/domain/repositories/auth_repository.dart';

class GetToken {
  final AuthRepository repository;

  GetToken(this.repository);

  Future<Either<Failure, String?>> call()async {
    return repository.getToken();
  }
}
