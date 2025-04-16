import 'package:contact_app1/business_logic/cubit/user_cubit.dart';
import 'package:contact_app1/data/models/users.dart';
import 'package:contact_app1/presentation/widgets/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String userId;
  final String token;

  const UserDetailsScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.userId,
    required this.token,
  }) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool isEditing = false;
  String? selectedRole;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);

    List<String> availableRoles = ["User", "Admin", "Guest"];
    selectedRole = availableRoles.contains(widget.role) ? widget.role : null;
  }

  void updateUser(BuildContext context) {
    final updatedUser = User(
      id: widget.userId,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      role: selectedRole,
      status: "",
    );

    print("UserId sent: ${widget.userId}");
    print("Updating user with data: ${updatedUser.toJson()}");

    context
        .read<UserCubit>()
        .updateUser(widget.userId, widget.token, updatedUser)
        .then((_) {
      print("User updated successfully.");
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
    }).catchError((error) {
      if (error is DioException) {
        print("Error occurred: ${error.response?.statusCode}");
        print("Error Data: ${error.response?.data}");
      } else {
        print("Error occurred: $error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: ''),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Home / Users / ${widget.firstName} ${widget.lastName}",
                style: const TextStyle(color: Colors.black, fontSize: 18)),
            const Divider(height: 20, color: Colors.grey),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık ve Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "User Details",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Text("Editing", style: TextStyle(fontSize: 16)),
                          Switch(
                            value: isEditing,
                            onChanged: (bool value) {
                              setState(() {
                                isEditing = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // İsim ve Soyisim
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            'First Name', _firstNameController, isEditing),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildTextField(
                            'Last Name', _lastNameController, isEditing),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildTextField("Email", _emailController, isEditing),
                  const SizedBox(height: 20),

                  _buildTextField("Phone", _phoneController, isEditing),
                  const SizedBox(height: 20),

                  // Rol Seçimi
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      value: selectedRole,
                      hint: const Text(
                        'Select your role',
                        style: TextStyle(color: Colors.grey),
                      ),
                      items: const ['Administrator', 'User']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                      onChanged: isEditing
                          ? (v) => setState(() => selectedRole = v)
                          : null,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please select a role'
                          : null,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.backgroundColor,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
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
                  Column(
                    children: [
                      _buildButton(
                        isEditing ? "Save" : "Edit",
                        isEditing ? AppColors.white : AppColors.blue,
                        () {
                          if (isEditing) {
                            updateUser(context);
                          }
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        isEditing,
                        icon: isEditing ? null : Icons.edit,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildButton(
                        "Cancel",
                        AppColors.blue,
                        () {
                          Navigator.pop(context);
                        },
                        false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FooterWidget()
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
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
      ),
    );
  }

  Widget _buildButton(
      String text, Color borderColor, VoidCallback onPressed, bool isSaveMode,
      {IconData? icon}) {
    return SizedBox(
      width: 325,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isSaveMode ? Colors.white : borderColor,
          backgroundColor: isSaveMode ? AppColors.blue : Colors.transparent,
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  color: isSaveMode ? Colors.white : borderColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isSaveMode ? Colors.white : borderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
