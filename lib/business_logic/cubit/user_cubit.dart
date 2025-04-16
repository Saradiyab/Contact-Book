import 'package:bloc/bloc.dart';
import 'package:contact_app1/data/models/users.dart';
import 'package:contact_app1/data/repository/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserInitial());

  List<User> _allUsers = []; 

  Future<void> createUser(String token, User user) async {
    try {
      emit(UserLoading());
      final createdUser = await userRepository.createUser(token, user);
      emit(UserCreated(user: createdUser));
      getUserDetails(token);
    } catch (e) {
      print("Error occurred: $e");
      emit(UserError(message: e.toString())); 
    }
  }

  Future<void> getUserDetails(String token) async {
    try {
      emit(UserLoading());
      final List<User> users = await userRepository.getUserDetails(token);
      _allUsers = users; 
      emit(UsersLoaded(users: users)); 
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  void filterUsers(String query) {
    final filtered = _allUsers.where((user) {
      final fullName = "${user.firstName} ${user.lastName}".toLowerCase();
      final email = user.email?.toLowerCase() ?? "";
      return fullName.contains(query.toLowerCase()) || email.contains(query.toLowerCase());
    }).toList();

    emit(UsersLoaded(users: filtered));
  }

  Future<void> deleteAllUsers(String token) async {
    try {
      emit(UserLoading());
      await userRepository.deleteAllUsers(token, "application/json"); 
      emit(AllUsersDeleted());
      getUserDetails(token); 
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> deleteOneUser(String id, String token) async {
    try {
      emit(UserLoading());
      await userRepository.deleteOneUser(id, token); 
      emit(UserDeleted());
      getUserDetails(token);
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> getOneUser(String userId, String token) async {
    try {
      emit(UserLoading());
      final user = await userRepository.getOneUserDetails(userId, token); 
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> updateUser(String userId, String token, User updatedUser) async {
    try {
      emit(UserLoading()); 
      print("Updating user with data: ${updatedUser.toJson()}");

      final updated = await userRepository.updateUser(userId, token, updatedUser);

      print("UserId sent: $userId");
      print("User updated successfully.");

      emit(UserUpdated(user: updated));
      await getUserDetails(token);
    } catch (e) {
      print("Error updating user: $e");
      emit(UserError(message: e.toString())); 
    }
  }
}
