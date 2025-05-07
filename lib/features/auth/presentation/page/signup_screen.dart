import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("createAccount".tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("accountDetails".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(child: _buildTextField("firstName".tr())),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField("lastName".tr())),
                ],
              ),
              _buildTextField("email".tr()),
              _buildTextField("password".tr(), isPassword: true),
              const SizedBox(height: 16),
              Text("billingDetails".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField("companyName".tr()),
              _buildTextField("vatNumber".tr()),
              _buildTextField("street".tr()),
              _buildTextField("street2Optional".tr()),
              _buildTextField("city".tr()),
              _buildTextField("state".tr()),
              _buildTextField("zip".tr()),
              _buildDropdown(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value!;
                      });
                    },
                  ),
                  Expanded(child: Text("agreeTerms".tr())),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("back".tr()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _agreeToTerms
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("registrationSuccess".tr())),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: Text("register".tr()),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, "/login_screen"),
                child: Text("signInInstead".tr()),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "© ITM Development | Contact Book | 2024",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "${"please Enter".tr()} $label";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "selectCountry".tr(),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        items: ["USA", "UK"]
            .map((country) => DropdownMenuItem(value: country, child: Text(country)))
            .toList(),
        onChanged: (value) {},
      ),
    );
  }
}
