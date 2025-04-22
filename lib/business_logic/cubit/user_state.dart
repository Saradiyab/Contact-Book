import 'package:contact_app1/data/models/users.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;
  UsersLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class UserLoaded extends UserState {
  final User user;
  UserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserCreated extends UserState {
  final User user;
  UserCreated({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UserState {
  final User user;
  UserUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AllUsersDeleted extends UserState {}

class UserDeleted extends UserState {}

class UserError extends UserState {
  final String message;
  UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
class UserSuccess extends UserState {
  final String message;
  UserSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

