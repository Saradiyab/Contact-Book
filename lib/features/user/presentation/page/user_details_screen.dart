import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/user/domain/entities/user.dart';
import 'package:contact_app1/features/user/presentation/bloc/user_cubit.dart';
import 'package:contact_app1/features/user/presentation/bloc/user_state.dart';
import 'package:contact_app1/core/widgets/custom_appbar.dart';
import 'package:contact_app1/core/widgets/custom_button.dart';
import 'package:contact_app1/core/widgets/custom_drawer.dart';
import 'package:contact_app1/core/widgets/custom_textfield.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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

    context
        .read<UserCubit>()
        .updateUser(widget.userId, widget.token, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.userUpdatedSuccess.tr())),
          );
          Navigator.pop(context, true);
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message.tr()}')),
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
                '${AppStrings.homeUser.tr()} ${widget.firstName} ${widget.lastName}',
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
              Expanded(
                  child: _buildInfoField(
                AppStrings.firstName.tr(),
                _firstNameController,
                keyboardType: TextInputType.name,
              )),
              const SizedBox(width: 20),
              Expanded(
                  child: _buildInfoField(
                AppStrings.lastName.tr(),
                _lastNameController,
                keyboardType: TextInputType.name,
              )),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoField(AppStrings.email.tr(), _emailController,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 20),
          _buildInfoField(AppStrings.phone.tr(), _phoneController,
              keyboardType: TextInputType.phone),
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
        Text(AppStrings.userDetails.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Text(AppStrings.editing.tr(),
                style: const TextStyle(fontSize: 16)),
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
    final roles = [AppStrings.administrator, AppStrings.user];

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        value: roles.contains(selectedRole) ? selectedRole : null,
        hint: Text(AppStrings.selectRole.tr(),
            style: const TextStyle(color: Colors.grey)),
        items: roles
            .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role.tr()),
                ))
            .toList(),
        onChanged: isEditing ? (v) => setState(() => selectedRole = v) : null,
        validator: (v) =>
            (v == null || v.isEmpty) ? AppStrings.selectRole.tr() : null,
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
          isEditing ? AppStrings.save.tr() : AppStrings.edit.tr(),
          AppColors.blue,
          () {
            if (isEditing) _onUpdateUser();
            setState(() => isEditing = !isEditing);
          },
          icon: isEditing ? null : Icons.edit,
          backgroundColor: isEditing ? AppColors.blue : AppColors.white,
          textColor: isEditing ? AppColors.white : AppColors.blue,
        ),
        const SizedBox(height: 20),
        _buildButton(
          AppStrings.cancel.tr(),
          AppColors.blue,
          () => Navigator.pop(context),
          textColor: AppColors.blue,
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color borderColor, VoidCallback onPressed,
      {Color? backgroundColor, IconData? icon, Color? textColor}) {
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
