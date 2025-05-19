import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact_app1/core/utils/logger.dart';
import 'package:contact_app1/features/auth/data/models/auth_response_model.dart';
import 'package:contact_app1/features/auth/data/models/login_request_model.dart';
import 'package:contact_app1/features/auth/data/models/register_request_model.dart';
import 'auth_remote_data_source.dart';

class AuthService implements AuthRemoteDataSource {
  late Dio dio;
  static final AuthService _instance = AuthService._privateConstructor();
  static SharedPreferences? _prefs;

  AuthService._privateConstructor() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://ms.itmd-b1.com:5123/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 20),
    );
    dio = Dio(options);
    _initPrefs();
  }

  factory AuthService() => _instance;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<AuthResponseModel?> login(LoginRequestModel loginRequest) async {
    await _initPrefs();
    try {
      final response = await dio.post('/api/login', data: loginRequest.toJson());
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        if (authResponse.token.isNotEmpty) {
          await saveToken(authResponse.token);
          logger.i("Token saved: ${authResponse.token}");
        }
        return authResponse;
      } else {
        return _handleErrorResponse(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      logger.e("Unexpected login error", error: e);
      return null;
    }
  }

  @override
  Future<AuthResponseModel?> register(RegisterRequestModel registerRequest) async {
    await _initPrefs();
    try {
      final response = await dio.post('/api/register', data: registerRequest.toJson());
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception("Unexpected response: ${response.data}");
      }
    } on DioException catch (e) {
      logger.e("Dio registration error", error: e);
      return AuthResponseModel(
        token: "",
        message: e.response?.data["message"] ?? "Registration failed.",
      );
    }
  }

  @override
  Future<void> logout() async {
    await _initPrefs();
    await _prefs?.remove("user_token");
    logger.i("User logged out and token cleared.");
  }

  @override
  Future<String?> getToken() async {
    await _initPrefs();
    final token = _prefs?.getString("user_token");
    logger.i("Retrieved token: $token");
    return token;
  }

  @override
  Future<void> checkToken() async {
    final token = await getToken();
    logger.i("Token check: $token");
  }

  Future<void> saveToken(String token) async {
    await _prefs?.setString('user_token', token);
  }

  AuthResponseModel _handleErrorResponse(Response response) {
    final errorMessage = response.data is Map<String, dynamic> && response.data.containsKey("message")
        ? response.data["message"]
        : "Unknown server error.";
    logger.e("API error response: $errorMessage");
    return AuthResponseModel(token: "", message: errorMessage);
  }

  AuthResponseModel _handleDioError(DioException e) {
    final msg = e.response?.data["message"] ?? "Network error occurred.";
    logger.e("DioException: $msg", error: e);
    return AuthResponseModel(token: "", message: msg);
  }
}
