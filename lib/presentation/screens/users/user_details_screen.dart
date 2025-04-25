import 'package:contact_app1/business_logic/cubit/user_cubit.dart';
import 'package:contact_app1/business_logic/cubit/user_state.dart';
import 'package:contact_app1/data/models/users.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_button.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_textfield.dart';
import 'package:contact_app1/presentation/widgets/custom/footer_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_appbar.dart';
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
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.userId,
    required this.token,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
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
    selectedRole = widget.role;
  }

  void _onUpdateUser() {
    final updatedUser = User(
      id: widget.userId,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      role: selectedRole ?? "User",
      status: "",
    );

    context.read<UserCubit>().updateUser(widget.userId, widget.token, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully!')),
          );
          Navigator.pop(context, true);
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: CustomAppBar(),
        drawer: CustomDrawer(token: widget.token),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                "Home / Users / ${widget.firstName} ${widget.lastName}",
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              const Divider(height: 20, color: Colors.grey),
              const SizedBox(height: 20),
              _buildUserForm(),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildInfoField('First Name', _firstNameController, keyboardType: TextInputType.name,)),
              const SizedBox(width: 20),
              Expanded(child: _buildInfoField('Last Name', _lastNameController, keyboardType: TextInputType.name,)),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoField("Email", _emailController, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 20),
          _buildInfoField("Phone", _phoneController, keyboardType: TextInputType.phone),
          const SizedBox(height: 20),
          _buildRoleDropdown(),
          const SizedBox(height: 40),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("User Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Row(
          children: [
            const Text("Editing", style: TextStyle(fontSize: 16)),
            Switch(
              value: isEditing,
              onChanged: (bool value) {
                setState(() => isEditing = value);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomTextField(
        controller: controller,
        hintText: label,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildRoleDropdown() {
    final roles = ['Administrator', 'User'];

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        value: roles.contains(selectedRole) ? selectedRole : null,
        hint: const Text('Select your role', style: TextStyle(color: Colors.grey)),
        items: roles
            .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                ))
            .toList(),
        onChanged: isEditing ? (v) => setState(() => selectedRole = v) : null,
        validator: (v) => (v == null || v.isEmpty) ? 'Please select a role' : null,
        decoration: const InputDecoration(
          filled: true,
          fillColor: AppColors.backgroundColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.blue, width: 3),
          ),
        ),
        dropdownStyleData: const DropdownStyleData(
          offset: Offset(0, 8),
          decoration: BoxDecoration(color: AppColors.white),
        ),
      ),
    );
  }

Widget _buildButtons() {
  return Column(
    children: [
      _buildButton(
        isEditing ? "Save" : "Edit",
        isEditing ? AppColors.blue : AppColors.blue, //arka plan kenari
        () {
          if (isEditing) _onUpdateUser();
          setState(() => isEditing = !isEditing);
        },
        icon: isEditing ? null : Icons.edit,
        backgroundColor: isEditing ? AppColors.blue : AppColors.white, //background button 
        textColor: isEditing ? AppColors.white : AppColors.blue, //metin
      ),
      const SizedBox(height: 20),
      _buildButton(
        "Cancel",
        AppColors.blue,
        () => Navigator.pop(context),
        textColor: AppColors.blue,
      ),
    ],
  );
}

 Widget _buildButton(
  String text, 
  Color borderColor, 
  VoidCallback onPressed, 
  { Color? backgroundColor, IconData? icon, Color? textColor}) {

  return CustomButton(
    label: text,
    icon: icon,
    onPressed: onPressed,
    backgroundColor: backgroundColor ?? Colors.white,
    borderColor: borderColor,
    textColor: textColor ?? borderColor, 
  );
}

}
