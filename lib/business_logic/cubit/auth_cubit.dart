import 'package:bloc/bloc.dart';
import 'package:contact_app1/data/models/Register.dart';
import 'package:contact_app1/data/repository/auth_repository.dart';
import 'package:contact_app1/data/models/login.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  /// **Login işlemi**
 Future<void> login(String email, String password) async {
  emit(AuthLoading());
  try {
    final loginRequest = LoginRequest(email: email, password: password);
    final response = await authRepository.login(loginRequest);

    if (response != null && response.token.isNotEmpty) {
      print("Token received successfully: ${response.token}");
      await authRepository.authService.saveToken(response.token); // Token kaydediliyor
      emit(AuthAuthenticated(response.token));
    } else {
      emit(AuthFailure(response?.message ?? "Login failed!"));
    }
  } catch (e) {
    emit(AuthFailure("An unexpected error occurred: ${e.toString()}"));
  }
}


  Future<void> register(RegisterRequest registerRequest) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.register(registerRequest);

      if (response != null && response.token.isNotEmpty) {
        await authRepository.authService.saveToken(response.token); 
        emit(AuthAuthenticated(response.token));
      } else {
        emit(AuthFailure(response?.message ?? "Registration failed!"));
      }
    } catch (e) {
      emit(AuthFailure("An error occurred during registration: ${e.toString()}"));
    }
  }

  /// **Logout işlemi**
  Future<void> logout() async {
    try {
      await authRepository.logout();
      emit(AuthInitial()); // Çıkış yapınca başlangıç durumuna dön
    } catch (e) {
      emit(AuthFailure("Error occurred during logout: ${e.toString()}"));
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
      emit(AuthFailure("Error checking auth status: ${e.toString()}"));
    }
  }
}
