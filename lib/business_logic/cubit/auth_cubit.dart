import 'package:bloc/bloc.dart';
import 'package:contact_app1/core/constants/strings.dart';
import 'package:contact_app1/data/models/register.dart';
import 'package:contact_app1/data/repository/auth_repository.dart';
import 'package:contact_app1/data/models/login.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final response = await authRepository.login(loginRequest);

      response.fold(
        (failure) {
          emit(AuthFailure(failure.message)); 
        },
        (authResponse) {
          print("Token received successfully: ${authResponse.token}");
          authRepository.authService.saveToken(authResponse.token);
          emit(AuthAuthenticated(authResponse.token));
          checkAuthStatus(); 
        },
      );
    } catch (e) {
      emit(AuthFailure("${MessageStrings.unexpectedLoginError} ${e.toString()}"));
    }
  }

  Future<void> register(RegisterRequest registerRequest) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.register(registerRequest);

      response.fold(
        (failure) {
          emit(AuthFailure(failure.message)); 
        },
        (authResponse) {
          authRepository.authService.saveToken(authResponse.token);
          emit(AuthAuthenticated(authResponse.token));
        },
      );
    } catch (e) {
      emit(AuthFailure("${MessageStrings.unexpectedRegisterError} ${e.toString()}"));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      await authRepository.authService.clearToken();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure("${MessageStrings.logoutError} ${e.toString()}"));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final token = await authRepository.getToken();
      if (token != null && token.isNotEmpty && token != "null") {
        emit(AuthAuthenticated(token));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure("${MessageStrings.tokenCheckError} ${e.toString()}"));
    }
  }
}
