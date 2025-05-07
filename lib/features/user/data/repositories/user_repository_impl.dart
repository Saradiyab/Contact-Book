// lib/features/user/data/repositories/user_repository_impl.dart

import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/user/data/datasources/user_remote_data_source.dart';
import 'package:contact_app1/features/user/data/models/user_model.dart';
import 'package:contact_app1/features/user/domain/entities/user.dart';
import 'package:contact_app1/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> createUser(String token, User user) async {
    try {
      final result = await remoteDataSource.createUser(
        token,
        UserModel.fromUser(user),
      );
      return Right(result.toUser());
    } catch (_) {
      return Left(ServerFailure(AppStrings.createUserError));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUserDetails(String token) async {
    try {
      final result = await remoteDataSource.getUserDetails(token);
      final users = result.map((model) => model.toUser()).toList();
      return Right(users);
    } catch (_) {
      return Left(ServerFailure(AppStrings.fetchUsersError));
    }
  }

  @override
  Future<Either<Failure, User>> getOneUserDetails(String userId, String token) async {
    try {
      final result = await remoteDataSource.getOneUserDetails(userId, token);
      return Right(result.toUser());
    } catch (_) {
      return Left(ServerFailure(AppStrings.fetchUsersError));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(String userId, String token, User user) async {
    try {
      final result = await remoteDataSource.updateUser(
        userId,
        token,
        UserModel.fromUser(user),
      );
      return Right(result.toUser());
    } catch (_) {
      return Left(ServerFailure(AppStrings.updateUserError));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAllUsers(String token, String contentType) async {
    try {
      await remoteDataSource.deleteAllUsers(token, contentType);
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure(AppStrings.deleteAllUsersError));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteOneUser(String id, String token) async {
    try {
      await remoteDataSource.deleteOneUser(id, token);
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure(AppStrings.deleteUserError));
    }
  }
}
