// auth_remote_data_source_impl.dart
import 'package:contact_app1/features/auth/data/models/auth_response_model.dart';
import 'package:contact_app1/features/auth/data/models/login_request_model.dart';
import 'package:contact_app1/features/auth/data/models/register_request_model.dart';
import 'auth_remote_data_source.dart';
import 'auth_service.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService authService;

  AuthRemoteDataSourceImpl({required this.authService});

  @override
  Future<AuthResponseModel?> login(LoginRequestModel loginRequest) {
    return authService.login(loginRequest);
  }

  @override
  Future<AuthResponseModel?> register(RegisterRequestModel registerRequest) {
    return authService.register(registerRequest);
  }

  @override
  Future<void> logout() {
    return authService.logout();
  }

  @override
  Future<String?> getToken() {
    return authService.getToken();
  }

  @override
  Future<void> checkToken() {
    return authService.checkToken();
  }
}
