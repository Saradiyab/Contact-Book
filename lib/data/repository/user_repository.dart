import 'package:contact_app1/core/constants/strings.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/data/api/users_service.dart';
import 'package:contact_app1/data/models/users.dart';
import 'package:dartz/dartz.dart';

class UserRepository {
  final UsersService usersService;

  UserRepository({required this.usersService});

  Future<Either<Failure, User>> createUser(String token, User createUser) async {
    try {
      final user = await usersService.createUser("Bearer $token", createUser);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(MessageStrings.createUserError));
    }
  }

  Future<Either<Failure, List<User>>> getUserDetails(String token) async {
    try {
      final users = await usersService.getUserDetails("Bearer $token");
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(MessageStrings.fetchUsersError));
    }
  }

  Future<Either<Failure, Unit>> deleteAllUsers(String token, String contentType) async {
    try {
      await usersService.deleteAllUsers("Bearer $token", contentType);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(MessageStrings.deleteAllUsersError));
    }
  }

  Future<Either<Failure, Unit>> deleteOneUser(String id, String token) async {
    try {
      await usersService.deleteOneUser(id, "Bearer $token");
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(MessageStrings.deleteUserError));
    }
  }

  Future<Either<Failure, User>> getOneUserDetails(String userId, String token) async {
    try {
      final user = await usersService.getOneUser(userId, "Bearer $token");
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(MessageStrings.fetchUsersError));
    }
  }

  Future<Either<Failure, User>> updateUser(String userId, String token, User updatedUser) async {
    try {
      final user = await usersService.userUpdate(userId, "Bearer $token", updatedUser);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(MessageStrings.updateUserError));
    }
  }
}
