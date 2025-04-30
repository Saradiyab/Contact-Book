import 'package:contact_app1/core/utils/logger.dart';
import 'package:contact_app1/features/data/models/auth.dart';
import 'package:contact_app1/features/data/models/login.dart';
import 'package:contact_app1/features/data/models/register.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
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

  Future<AuthResponse?> login(LoginRequest loginRequest) async {
    await _initPrefs();
    try {
      Response response = await dio.post('/api/login', data: loginRequest.toJson());
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        AuthResponse authResponse = AuthResponse.fromJson(response.data);
        if (authResponse.token.isNotEmpty) {
          await saveToken(authResponse.token);
            logger.i("Token successfully registered: ${authResponse.token}");
        }
        return authResponse;
      } else {
        return _handleErrorResponse(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
        logger.i("Unexpected error: $e");
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    await _initPrefs();
    await _prefs?.setString('user_token', token);
  }

  Future<String?> getToken() async {
    await _initPrefs();
    final token = _prefs?.getString("user_token");
      logger.i("[AuthService] getToken() was called. Token: $token");
    return token;
  }

  Future<void> clearToken() async {
    await _initPrefs();
    await _prefs?.remove('user_token'); 
  }

  Future<void> checkToken() async {
    String? token = await getToken();
      logger.i("Registered Token: $token");
  }

  Future<void> logout() async {
    await _initPrefs();
    await _prefs?.remove("user_token");
  }

  Future<AuthResponse?> register(RegisterRequest registerRequest) async {
    await _initPrefs();
    try {
      Response response = await dio.post('/api/register', data: registerRequest.toJson());
        logger.i("API Response Status Code: ${response.statusCode}");
        logger.i("API Response Data: ${response.data}");
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception("API responded in unexpected format: ${response.data}");
      }
    } on DioException catch (e) {
        logger.i("DioException: ${e.response?.statusCode} - ${e.response?.data}");
      return AuthResponse(
        token: "",
        message: e.response?.data["message"] ?? "Registration failed!",
      );
    }
  }

  AuthResponse _handleErrorResponse(Response response) {
    final errorMessage = response.data is Map<String, dynamic> &&
            response.data.containsKey("message")
        ? response.data["message"]
        : "An unknown error occurred.";
      logger.i("API Error Response: ${response.statusCode} - $errorMessage");
    return AuthResponse(token: "", message: errorMessage);
  }

  AuthResponse _handleDioError(DioException e) {
    if (e.response != null) {
        logger.i("DioException: ${e.response?.statusCode} - ${e.response?.data}");
      return AuthResponse(
        token: "",
        message: e.response?.data["message"] ?? "An unexpected error occurred.",
      );
    } else {
        logger.i("Network Error: ${e.message}");
      return AuthResponse(
        token: "",
        message: "Network error. Check your internet connection.",
      );
    }
  }
}


