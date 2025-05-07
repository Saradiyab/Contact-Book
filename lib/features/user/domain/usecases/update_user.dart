// domain/usecases/update_user.dart

import 'package:contact_app1/features/user/domain/entities/user.dart';
import 'package:contact_app1/features/user/domain/repositories/user_repository.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<Either<Failure, User>> call(String userId, String token, User updatedUser) async {
    return await repository.updateUser(userId, token, updatedUser);
  }
}
