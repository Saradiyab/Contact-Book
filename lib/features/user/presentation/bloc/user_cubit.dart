import 'package:bloc/bloc.dart';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/user/domain/entities/user.dart';
import 'package:contact_app1/features/user/domain/usecases/create_user.dart';
import 'package:contact_app1/features/user/domain/usecases/delete_all_users.dart';
import 'package:contact_app1/features/user/domain/usecases/get_users.dart';
import 'package:contact_app1/features/user/domain/usecases/update_user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final CreateUser createUserUseCase;
  final DeleteAllUsers deleteAllUsersUseCase;
  final GetUsers getUsersUseCase;
  final UpdateUser updateUserUseCase;

  UserCubit({
    required this.createUserUseCase,
    required this.deleteAllUsersUseCase,
    required this.getUsersUseCase,
    required this.updateUserUseCase,
  }) : super(UserInitial());

  List<User> _allUsers = [];

  // Create a new user using CreateUser UseCase
  Future<void> createUser(String token, User user) async {
    emit(UserLoading());
    final result = await createUserUseCase(token, user);
    result.fold(
      (failure) => emit(UserError(message: failure.message.tr())),
      (createdUser) async {
        emit(UserCreated(user: createdUser));
        await getUserDetails(token);
        emit(UserSuccess(message: AppStrings.userCreatedSuccess.tr()));
      },
    );
  }

  // Get user details using GetUsers UseCase
  Future<void> getUserDetails(String token) async {
    emit(UserLoading());
    final result = await getUsersUseCase(token);
    result.fold(
      (failure) => emit(UserError(message: failure.message.tr())),
      (users) {
        _allUsers = users;
        emit(UsersLoaded(users: users));
      },
    );
  }

  // Filter users by a query
  void filterUsers(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = _allUsers.where((user) {
      final fullName = "${user.firstName.tr()} ${user.lastName.tr()}".toLowerCase();
      final email = user.email?.toLowerCase() ?? "";
      return fullName.contains(lowerQuery) || email.contains(lowerQuery);
    }).toList();

    emit(UsersLoaded(users: filtered));
  }

  // Delete selected users using DeleteAllUsers UseCase
  Future<void> deleteSelectedUsers(Set<String> userIds, String token) async {
    emit(UserLoading());

    for (final id in userIds) {
      final result = await deleteAllUsersUseCase(id, token);
      final isFailure = result.fold(
        (failure) {
          emit(UserError(message: failure.message.tr()));
          return true;
        },
        (_) => false,
      );
      if (isFailure) return;
    }

    emit(UserDeleted());
    await getUserDetails(token);
    emit(UserSuccess(message: AppStrings.usersDeletedSuccess.tr()));
  }

  // Delete all users using DeleteAllUsers UseCase
  Future<void> deleteAllUsers(String token) async {
    emit(UserLoading());
    final result = await deleteAllUsersUseCase(token,"application/json");
    result.fold(
      (failure) => emit(UserError(message: failure.message.tr())),
      (_) async {
        emit(AllUsersDeleted());
        await getUserDetails(token);
        emit(UserSuccess(message: AppStrings.usersDeletedSuccess.tr()));
      },
    );
  }

  // Update user using UpdateUser UseCase
  Future<void> updateUser(String userId, String token, User updatedUser) async {
    emit(UserLoading());
    final result = await updateUserUseCase(userId, token, updatedUser);
    result.fold(
      (failure) => emit(UserError(message: failure.message.tr())),
      (user) async {
        emit(UserUpdated(user: user));
        await getUserDetails(token);
        emit(UserSuccess(message: AppStrings.userUpdatedSuccess.tr()));
      },
    );
  }
}
