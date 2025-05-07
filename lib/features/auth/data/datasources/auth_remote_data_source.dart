import 'package:contact_app1/features/auth/data/models/auth_response_model.dart';
import 'package:contact_app1/features/auth/data/models/login_request_model.dart';
import 'package:contact_app1/features/auth/data/models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel?> login(LoginRequestModel loginRequest);
  Future<AuthResponseModel?> register(RegisterRequestModel registerRequest);
  Future<void> logout();
  Future<String?> getToken();
  Future<void> checkToken();
}
