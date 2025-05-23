import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/features/auth/data/models/register_request_model.dart';
import 'package:contact_app1/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController vatController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController street2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedCountry;
  bool agreeToTerms = false;
  bool isEditing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("registrationSuccess".tr()),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, "/login_screen");
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    "createAccount".tr(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildFormCard(),
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        onChanged: (value) => setState(() => agreeToTerms = value!),
                      ),
                      Expanded(child: Text("agreeTerms".tr())),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        _buildButton("back".tr(), AppColors.blue, () => Navigator.pop(context)),
                        const SizedBox(height: 18),
                        _buildButton("register".tr(), AppColors.blue, _register),
                      ],
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, "/login_screen"),
                      child: Text(
                        "signInInstead".tr(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.blue),
                      ),
                    ),
                  ),
                  const FooterWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("accountDetails".tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkgrey)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTextField("firstName".tr(), firstNameController)),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField("lastName".tr(), lastNameController)),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextField("email".tr(), emailController),
          const SizedBox(height: 10),
          _buildTextField("phoneNumber".tr(), phoneController),
          const SizedBox(height: 10),
          _buildPasswordField("password".tr(), passwordController),
          const SizedBox(height: 20),
          Text("billingDetails".tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkgrey)),
          const SizedBox(height: 10),
          _buildTextField("companyName".tr(), companyController),
          const SizedBox(height: 10),
          _buildTextField("vatNumber".tr(), vatController),
          const SizedBox(height: 10),
          _buildTextField("street".tr(), streetController),
          const SizedBox(height: 10),
          _buildOptionalTextField("street2Optional".tr(), street2Controller),
          _buildTextField("city".tr(), cityController),
          const SizedBox(height: 10),
          _buildTextField("state".tr(), stateController),
          const SizedBox(height: 10),
          _buildTextField("zip".tr(), zipController),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedCountry,
            decoration: InputDecoration(
              labelText: "selectCountry".tr(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.blue, width: 2),
              ),
            ),
            items: ["USA", "UK"].map((country) => DropdownMenuItem(value: country, child: Text(country))).toList(),
            onChanged: (value) => setState(() => selectedCountry = value),
            validator: (value) => value == null ? "pleaseSelectCountry".tr() : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) => value == null || value.trim().isEmpty ? "$label ${'isRequired'.tr()}" : null,
      decoration: _inputDecoration(label),
      cursorColor: AppColors.blue,
    );
  }

  Widget _buildOptionalTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      cursorColor: AppColors.blue,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) => value == null || value.trim().isEmpty ? "$label ${'isRequired'.tr()}" : null,
      decoration: _inputDecoration(label),
      cursorColor: AppColors.blue,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.backgroundColor,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.blue, width: 2),
      ),
      floatingLabelStyle: const TextStyle(color: AppColors.blue),
    );
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    if (!agreeToTerms || selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(!agreeToTerms ? "mustAgree".tr() : "pleaseSelectCountry".tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authCubit = context.read<AuthCubit>();
    final request = RegisterRequestModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      companyName: companyController.text.trim(),
      vatNumber: vatController.text.trim(),
      streetOne: streetController.text.trim(),
      streetTwo: street2Controller.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      zip: zipController.text.trim(),
      country: selectedCountry!,
      phoneNumber: phoneController.text.trim(),
    );

    authCubit.register(request);
  }

  Widget _buildButton(String text, Color borderColor, VoidCallback onPressed) {
    bool isRegisterButton = text == "register".tr();
    return SizedBox(
      width: 325,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: borderColor,
          backgroundColor: isRegisterButton ? AppColors.blue : Colors.white,
          side: BorderSide(color: AppColors.blue, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isEditing && isRegisterButton ? Colors.white : borderColor,
          ),
        ),
      ),
    );
  }
}
