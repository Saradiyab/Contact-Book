import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/auth/domain/repositories/auth_repository.dart';

class CheckToken {
  final AuthRepository repository;

  CheckToken(this.repository);

  Future<Either<Failure, void>> call()async {
    return repository.checkToken();
  }
}
