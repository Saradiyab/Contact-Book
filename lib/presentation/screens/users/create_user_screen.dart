import 'package:contact_app1/presentation/widgets/custom_appbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/business_logic/cubit/user_cubit.dart';
import 'package:contact_app1/data/models/users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';

class CreateUserScreen extends StatefulWidget {
  final String userToken;

  const CreateUserScreen({Key? key, required this.userToken}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isUnlocked = false;

  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Home / Users / Create User",
                style: TextStyle(color: Colors.black, fontSize: 18)),
            Divider(color: AppColors.lightgrey),
            const SizedBox(height: 16),
            Container(
              width: 357,
              height: 600,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 1),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "User Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Text("Unlocked",
                                style: TextStyle(fontSize: 16)),
                            Switch(
                              value: isUnlocked,
                              onChanged: (bool value) {
                                setState(() {
                                  isUnlocked = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoField(
                              'First Name', _firstNameController, true),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildInfoField(
                              'Last Name', _lastNameController, true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoField('Email', _emailController, true),
                    const SizedBox(height: 20),
                    _buildInfoField('Phone Number', _phoneController, true),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 320,
                      height: 48,
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        value: selectedRole,
                        hint: const Text(
                          'Select your user',
                          style: TextStyle(color: Colors.grey),
                        ),
                        items: const ['Administrator', 'User']
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => selectedRole = v),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please select user type'
                            : null,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundColor,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.blue, width: 3),
                          ),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          offset: Offset(0, 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildButton('Save', AppColors.blue, () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final newUser = User(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                          phoneNumber: _phoneController.text,
                          status: "",
                          role: selectedRole,
                        );

                        await context
                            .read<UserCubit>()
                            .createUser(widget.userToken, newUser);

                        Navigator.pop(context, true);
                      }
                    }, backgroundColor: AppColors.blue),

                    const SizedBox(height: 20),

                    // Back Button
                    _buildButton('Back', AppColors.blue, () {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  // TextField helper
  Widget _buildInfoField(
      String label, TextEditingController controller, bool isEditing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: !isEditing,
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
        ),
        cursorColor: AppColors.blue,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Button helper
  Widget _buildButton(String text, Color borderColor, VoidCallback onPressed,
      {Widget? child, Color? backgroundColor}) {
    return SizedBox(
      width: 325,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: backgroundColor ?? Colors.white,
          backgroundColor: backgroundColor ?? Colors.white,
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: child ??
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: backgroundColor != null ? Colors.white : borderColor,
              ),
            ),
      ),
    );
  }
}
