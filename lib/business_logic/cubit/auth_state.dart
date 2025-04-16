part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// **Başlangıç Durumu**
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// **Yükleniyor Durumu**
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// **Başarılı Giriş Durumu**
class AuthAuthenticated extends AuthState {
  final String token;

  const AuthAuthenticated(this.token);

  @override
  List<Object?> get props => [token];
}

/// **Başarısızlık Durumu (Hata)**
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
