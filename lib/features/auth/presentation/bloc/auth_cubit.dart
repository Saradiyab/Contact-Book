import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import 'package:contact_app1/features/auth/domain/entities/login_credentials.dart';
import 'package:contact_app1/features/auth/domain/entities/register_info.dart';
import 'package:contact_app1/features/auth/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

final logger = Logger();

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final credentials = LoginCredentials(email: email, password: password);
    final result = await authRepository.login(credentials);

    result.fold(
      (failure) => emit(AuthFailure(failure.message.tr())),
      (authResponse) async {
        logger.i("Token received successfully: ${authResponse.token}");
        emit(AuthAuthenticated(authResponse.token));
        await checkAuthStatus();
      },
    );
  }

  Future<void> register(RegisterInfo registerInfo) async {
    emit(AuthLoading());
    final result = await authRepository.register(registerInfo);

    result.fold(
      (failure) => emit(AuthFailure(failure.message.tr())),
      (authResponse) async {
        emit(AuthAuthenticated(authResponse.token));
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthFailure(failure.message.tr())),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await authRepository.getToken();

    result.fold(
      (failure) => emit(AuthFailure(failure.message.tr())),
      (token) {
        if (token != null && token.isNotEmpty && token != "null") {
          emit(AuthAuthenticated(token));
        } else {
          emit(AuthInitial());
        }
      },
    );
  }
}
