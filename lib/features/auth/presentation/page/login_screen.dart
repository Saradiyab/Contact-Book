import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:contact_app1/features/auth/presentation/page/register_screen.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AuthCubit _authCubit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.emailPasswordEmpty.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await _authCubit.login(email, password);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home_screen');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWidget(),
                  const SizedBox(height: 40),
                  LoginForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    isLoading: _isLoading,
                    onLogin: login,
                  ),
                  const SizedBox(height: 25),
                  const DividerRow(),
                  const SizedBox(height: 40),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const FooterWidget(),
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
            MaterialPageRoute(builder: (context) => const RegisterScreen()),
          );
        },
        child: Text(
          AppStrings.signUp.tr(),
          style: const TextStyle(color: AppColors.blue, fontSize: 16),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Logo_Vertical.png',
      width: 145.29,
      height: 151,
    );
  }
}

class DividerRow extends StatelessWidget {
  const DividerRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.dividercolor,
            thickness: 1,
            endIndent: 10,
          ),
        ),
        Text(
          AppStrings.dontHaveAccount.tr(),
          style: const TextStyle(color: AppColors.black),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.dividercolor,
            thickness: 1,
            indent: 10,
          ),
        ),
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(emailController, AppStrings.email.tr()),
        const SizedBox(height: 15),
        _buildTextField(passwordController, AppStrings.password.tr(), obscureText: true),
        const SizedBox(height: 20),
        _buildLoginButton(context),
      ],
    );
  }
Widget _buildTextField(TextEditingController controller, String label,
    {bool obscureText = false}) {
  return SizedBox(
    width: 358, 
    height: 52, 
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: AppColors.backgroundColor,
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.blue,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12, 
        ),
      ),
      cursorColor: AppColors.blue,
    ),
  );
}


  Widget _buildLoginButton(BuildContext context) {
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
        onPressed: isLoading ? null : onLogin,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                AppStrings.signIn.tr(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}
