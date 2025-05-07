import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/user/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> createUser(String token, User createUser);
  Future<Either<Failure, List<User>>> getUserDetails(String token);
  Future<Either<Failure, User>> getOneUserDetails(String userId, String token);
  Future<Either<Failure, User>> updateUser(String userId, String token, User updatedUser);
  Future<Either<Failure, Unit>> deleteAllUsers(String token, String contentType);
  Future<Either<Failure, Unit>> deleteOneUser(String id, String token);
}
