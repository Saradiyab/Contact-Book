import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/data/api/auth_servic.dart';
import 'package:contact_app1/presentation/screens/auth/register_screen.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/data/models/login.dart';
import 'package:contact_app1/data/repository/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepository authRepository = AuthRepository(authService: AuthService());

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email and password cannot be blank."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final response = await authRepository.login(loginRequest);

      if (response != null && response.token.isNotEmpty) {
        print("Login successful! Token: ${response.token}");
        Navigator.pushReplacementNamed(context, '/home_screen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed. Please check your credentials."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView( // Taşma olmasın diye eklendi
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/Logo_Vertical.png',
                  width: 145.29,
                  height: 151,
                ),
                const SizedBox(height: 40),
                _buildTextField(emailController, "Email"),
                const SizedBox(height: 15),
                _buildTextField(passwordController, "Password", obscureText: true),
                const SizedBox(height: 20),
                _buildLoginButton(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.dividercolor,
                        thickness: 1,
                        endIndent: 10,
                      ),
                    ),
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: AppColors.black),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.dividercolor,
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundColor,
              labelText: label,
              labelStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.blue, width: 3),
              ),
              floatingLabelStyle: const TextStyle(color: AppColors.blue),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            ),
            cursorColor: AppColors.blue,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        onPressed: login,
        child: const Text(
          "Sign in",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: 143,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.blue, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
        child: const Text(
          "Sign up",
          style: TextStyle(color: AppColors.blue, fontSize: 16),
        ),
      ),
    );
  }
}
