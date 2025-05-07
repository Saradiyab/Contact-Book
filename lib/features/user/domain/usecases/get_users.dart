// domain/usecases/get_users.dart

import 'package:contact_app1/features/user/domain/entities/user.dart';
import 'package:contact_app1/features/user/domain/repositories/user_repository.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, List<User>>> call(String token) async {
    return await repository.getUserDetails(token);
  }
}
