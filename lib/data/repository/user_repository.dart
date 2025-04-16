import 'package:contact_app1/data/api/users_service.dart';
import 'package:contact_app1/data/models/users.dart';

class UserRepository {
  final UsersService usersService;

  UserRepository({required this.usersService});

  Future<User> createUser(String token, User createUser) async {
    try {
      final createdUser = await usersService.createUser("Bearer $token", createUser);
      return createdUser;
    } catch (e) {
      rethrow; 
    }
  }

  Future<List<User>> getUserDetails(String token) async {
    try {
      final users = await usersService.getUserDetails("Bearer $token");
      return users;
    } catch (e) {
      rethrow;
    }
  }

Future<void> deleteAllUsers(String token, String contentType) async {
  try {
    await usersService.deleteAllUsers("Bearer $token", contentType); 
  } catch (e) {
    rethrow;
  }
}

Future<void> deleteOneUser(String id, String token) async {
  try {
    await usersService.deleteOneUser(id, "Bearer $token"); 
  } catch (e) {
    rethrow;
  }
}

Future<User> getOneUserDetails(String userId, String token) async {
  try {
    final user = await usersService.getOneUser(userId, "Bearer $token"); 
    return user;
  } catch (e) {
    rethrow;
  }
}

Future<User> updateUser(String userId, String token, User updatedUser) async {
  try {
    final response = await usersService.userUpdate(
      userId, 
      "Bearer $token",
      updatedUser,
    );
    return response;
  } catch (e) {
    throw Exception("Failed to update user: $e");
  }
}

}
