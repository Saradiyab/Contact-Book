import 'package:bloc/bloc.dart';
import 'package:contact_app1/features/auth/domain/usecases/check_token.dart';
import 'package:contact_app1/features/auth/domain/usecases/get_token.dart';
import 'package:contact_app1/features/auth/domain/usecases/login_user.dart';
import 'package:contact_app1/features/auth/domain/usecases/logout_user.dart';
import 'package:contact_app1/features/auth/domain/usecases/register_user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import 'package:contact_app1/features/auth/domain/entities/login_credentials.dart';
import 'package:contact_app1/features/auth/domain/entities/register_info.dart';

part 'auth_state.dart';

final logger = Logger();

class AuthCubit extends Cubit<AuthState> {
  final CheckToken checkTokenUseCase;
  final GetToken getTokenUseCase;
  final LoginUser loginUserUseCase;
  final LogoutUser logoutUserUseCase;
  final RegisterUser registerUserUseCase;

 AuthCubit({
  required this.getTokenUseCase,
  required this.loginUserUseCase,
  required this.logoutUserUseCase,
  required this.registerUserUseCase,
  required this.checkTokenUseCase,
}) : super(AuthInitial());


  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final credentials = LoginCredentials(email: email, password: password);
    final result = await loginUserUseCase(credentials);

    result.fold(
      (failure) => emit(AuthFailure(failure.message.tr())),
      (authResponse) async {
        logger.i("Token received successfully: ${authResponse.token}");
        emit(AuthAuthenticated(authResponse.token));
        await checkAuthStatus(); // İsteğe bağlı
      },
    );
  }

  Future<void> register(RegisterInfo registerInfo) async {
    emit(AuthLoading());
    final result = await registerUserUseCase(registerInfo);

    result.fold(
      (failure) => emit(AuthFailure(failure.message.tr())),
      (authResponse) => emit(AuthAuthenticated(authResponse.token)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUserUseCase();

    result.fold(
      (failure) => emit(AuthFailure(failure.message.tr())),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await getTokenUseCase();

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
