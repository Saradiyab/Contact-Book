// lib/features/user/data/datasources/user_remote_data_source_impl.dart
import 'package:contact_app1/features/user/data/datasources/users_service.dart';
import 'package:contact_app1/features/user/data/models/user_model.dart';
import 'package:contact_app1/features/user/data/datasources/user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final UsersService userservice;

  UserRemoteDataSourceImpl({required this.userservice});

  @override
  Future<UserModel> createUser(String token, UserModel user) async {
    return await userservice.createUser("Bearer $token", user);
  }

  @override
  Future<List<UserModel>> getUserDetails(String token) async {
    return await userservice.getUserDetails("Bearer $token");
  }

  @override
  Future<UserModel> getOneUserDetails(String userId, String token) async {
    return await userservice.getOneUser(userId, "Bearer $token");
  }

  @override
  Future<UserModel> updateUser(String userId, String token, UserModel user) async {
    return await userservice.userUpdate(userId, "Bearer $token", user);
  }

  @override
  Future<void> deleteAllUsers(String token, String contentType) async {
    await userservice.deleteAllUsers("Bearer $token", contentType);
  }

  @override
  Future<void> deleteOneUser(String id, String token) async {
    await userservice.deleteOneUser(id, "Bearer $token");
  }
}

