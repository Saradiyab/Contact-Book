import 'package:bloc/bloc.dart';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/user/domain/entities/user.dart';
import 'package:contact_app1/features/user/domain/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserInitial());

  List<User> _allUsers = [];

  Future<void> createUser(String token, User user) async {
    emit(UserLoading());
    final result = await userRepository.createUser(token, user);
    result.fold(
      (failure) => emit(UserError(message: failure.message.tr())),
      (createdUser) async {
        emit(UserCreated(user: createdUser));
        await getUserDetails(token);
        emit(UserSuccess(message: AppStrings.userCreatedSuccess.tr()));
      },
    );
  }

  Future<void> getUserDetails(String token) async {
    emit(UserLoading());
    final result = await userRepository.getUserDetails(token);
    result.fold(
      (failure) => emit(UserError(message: failure.message.tr())),
      (users) {
        _allUsers = users;
        emit(UsersLoaded(users: users));
      },
    );
  }

  void filterUsers(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = _allUsers.where((user) {
      final fullName = "${user.firstName.tr()} ${user.lastName.tr()}".toLowerCase();
      final email = user.email?.toLowerCase() ?? "";
      return fullName.contains(lowerQuery) || email.contains(lowerQuery);
    }).toList();

    emit(UsersLoaded(users: filtered));
  }

  Future<void> deleteSelectedUsers(Set<String> userIds, String token) async {
    emit(UserLoading());

    for (final id in userIds) {
      final result = await userRepository.deleteOneUser(id, token);
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

  Future<void> deleteAllUsers(String token) async {
    emit(UserLoading());
    final result = await userRepository.deleteAllUsers(token, "application/json");
    result.fold(
      (failure) => emit(UserError(message: failure.message.tr())),
      (_) async {
        emit(AllUsersDeleted());
        await getUserDetails(token);
        emit(UserSuccess(message: AppStrings.usersDeletedSuccess.tr()));
      },
    );
  }

  Future<void> updateUser(String userId, String token, User updatedUser) async {
    emit(UserLoading());
    final result = await userRepository.updateUser(userId, token, updatedUser);
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
