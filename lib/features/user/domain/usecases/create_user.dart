// domain/usecases/create_user.dart

import 'package:contact_app1/features/user/domain/entities/user.dart';
import 'package:contact_app1/features/user/domain/repositories/user_repository.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<Either<Failure, User>> call(String token, User user) async {
    return await repository.createUser(token, user);
  }
}
