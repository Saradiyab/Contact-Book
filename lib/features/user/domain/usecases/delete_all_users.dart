// domain/usecases/delete_all_users.dart

import 'package:contact_app1/features/user/domain/repositories/user_repository.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class DeleteAllUsers {
  final UserRepository repository;

  DeleteAllUsers(this.repository);

  Future<Either<Failure, Unit>> call(String token, String contentType) async {
    return await repository.deleteAllUsers(token, contentType);
  }
}
