import 'package:contact_app1/data/models/Register.dart';
import 'package:dio/dio.dart';
import 'package:contact_app1/data/models/login.dart';
import 'package:contact_app1/data/models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late Dio dio;

  AuthService() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://ms.itmd-b1.com:5123/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 20),
    );

    dio = Dio(options);
  }

  Future<AuthResponse?> login(LoginRequest loginRequest) async {
    try {
      Response response = await dio.post('/api/login', data: loginRequest.toJson());

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        AuthResponse authResponse = AuthResponse.fromJson(response.data);

        if (authResponse.token.isNotEmpty) {
          await saveToken(authResponse.token);
          print("Token successfully registered: ${authResponse.token}");
        }

        return authResponse;
      } else {
        return _handleErrorResponse(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_token', token); 
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("user_token");  
  print("[AuthService] getToken() was called. Token: $token");
  return token;
}

  Future<void> checkToken() async {
    String? token = await getToken();
    print("Registered Token: $token");
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_token");
  }

  Future<AuthResponse?> register(RegisterRequest registerRequest) async {
  try {
    Response response = await dio.post('/api/register', data: registerRequest.toJson());

    print("API Response Status Code: ${response.statusCode}");
    print("API Response Data: ${response.data}"); 

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      return AuthResponse.fromJson(response.data);
    } else {
      throw Exception("API responded in unexpected format: ${response.data}");
    }
  } on DioException catch (e) {
    print("DioException: ${e.response?.statusCode} - ${e.response?.data}");
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

    print("API Error Response: ${response.statusCode} - $errorMessage");

    return AuthResponse(token: "", message: errorMessage);
  }

  AuthResponse _handleDioError(DioException e) {
    if (e.response != null) {
      print("DioException: ${e.response?.statusCode} - ${e.response?.data}");

      return AuthResponse(
        token: "",
        message: e.response?.data["message"] ?? "An unexpected error occurred.",
      );
    } else {
      print("Network Error: ${e.message}");
      return AuthResponse(
        token: "",
        message: "Network error. Check your internet connection.",
      );
    }
  }
}