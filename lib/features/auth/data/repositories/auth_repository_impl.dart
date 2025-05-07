import 'package:contact_app1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/auth/data/models/login_request_model.dart';
import 'package:contact_app1/features/auth/data/models/register_request_model.dart';
import 'package:contact_app1/features/auth/domain/entities/auth_response.dart';
import 'package:contact_app1/features/auth/domain/entities/login_credentials.dart';
import 'package:contact_app1/features/auth/domain/entities/register_info.dart';
import 'package:contact_app1/features/auth/domain/repositories/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, AuthResponse>> login(LoginCredentials credentials) async {
    try {
      final response = await authRemoteDataSource.login(LoginRequestModel(
        email: credentials.email,
        password: credentials.password,
      ));

      if (response == null || response.token.isEmpty) {
        return Left(ServerFailure(AppStrings.loginInvalidResponse));
      }
      return Right(response);
    } catch (e) {
      logger.e("AuthRepository → Login Error", error: e);
      return Left(NetworkFailure(AppStrings.loginFailed.tr()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(RegisterInfo info) async {
    try {
      final response = await authRemoteDataSource.register(RegisterRequestModel(
        firstName: info.firstName,
        lastName: info.lastName,
        email: info.email,
        phoneNumber: info.phoneNumber,
        password: info.password,
        companyName: info.companyName,
        vatNumber: info.vatNumber,
        streetOne: info.streetOne,
        streetTwo: info.streetTwo,
        city: info.city,
        state: info.state,
        zip: info.zip,
        country: info.country,
      ));

      if (response == null || response.token.isEmpty) {
        return Left(ServerFailure(AppStrings.registrationInvalidResponse));
      }
      return Right(response);
    } catch (e) {
      logger.e("AuthRepository → Register Error", error: e);
      return Left(NetworkFailure(AppStrings.registrationFailed.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      logger.e("AuthRepository → Logout Error", error: e);
      return Left(NetworkFailure(AppStrings.logoutFailed.tr()));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await authRemoteDataSource.getToken();
      return Right(token);
    } catch (e) {
      logger.e("AuthRepository → Get Token Error", error: e);
      return Left(NetworkFailure(AppStrings.tokenCheckFailed.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> checkToken() async {
    try {
      await authRemoteDataSource.checkToken();
      return const Right(null);
    } catch (e) {
      logger.e("AuthRepository → Token Check Error", error: e);
      return Left(NetworkFailure(AppStrings.tokenCheckFailed.tr()));
    }
  }
}
