import 'package:bloc/bloc.dart';
import 'package:contact_app1/features/data/models/login.dart';
import 'package:contact_app1/features/data/models/register.dart';
import 'package:contact_app1/features/data/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:logger/logger.dart';
part 'auth_state.dart';

final logger = Logger();

class AuthCubit extends Cubit<AuthState> {
  

  final AuthRepository authRepository;
  

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final loginRequest = LoginRequest(email: email, password: password);
    final result = await authRepository.login(loginRequest);

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (authResponse) async {
        logger.i("Token received successfully: ${authResponse.token}");
        await authRepository.authService.saveToken(authResponse.token);
        emit(AuthAuthenticated(authResponse.token));
        await checkAuthStatus();
      },
    );
  }

  Future<void> register(RegisterRequest registerRequest) async {
    emit(AuthLoading());
    final result = await authRepository.register(registerRequest);

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (authResponse) async {
        await authRepository.authService.saveToken(authResponse.token);
        emit(AuthAuthenticated(authResponse.token));
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await authRepository.logout();

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (_) async {
        await authRepository.authService.clearToken();
        emit(AuthInitial());
      },
    );
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await authRepository.getToken();

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
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
