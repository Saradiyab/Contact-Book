import 'package:contact_app1/features/user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> createUser(String token, UserModel user);
  Future<List<UserModel>> getUserDetails(String token);
  Future<UserModel> getOneUserDetails(String userId, String token);
  Future<UserModel> updateUser(String userId, String token, UserModel user);
  Future<void> deleteAllUsers(String token, String contentType);
  Future<void> deleteOneUser(String id, String token);
}
