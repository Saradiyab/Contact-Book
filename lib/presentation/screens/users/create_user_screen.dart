import 'package:contact_app1/presentation/widgets/custom/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_button.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_textfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/business_logic/cubit/user_cubit.dart';
import 'package:contact_app1/data/models/users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/custom/footer_widget.dart';

class CreateUserScreen extends StatefulWidget {
  final String userToken;

  const CreateUserScreen({super.key, required this.userToken});

  @override
  CreateUserScreenState createState() => CreateUserScreenState();
}

class CreateUserScreenState extends State<CreateUserScreen> {
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
            _buildHeader(),
            const SizedBox(height: 16),
            _buildUserForm(),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Home / Users / Create User",
      style: TextStyle(color: Colors.black, fontSize: 18),
    );
  }

  Widget _buildUserForm() {
    return Container(
      width: 357,
      height: 600,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserDetailsHeader(),
            const SizedBox(height: 16),
            _buildTextFields(),
            const SizedBox(height: 20),
            _buildRoleDropdown(),
            const SizedBox(height: 40),
            _buildSaveButton(),
            const SizedBox(height: 20),
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  // User Details Header
  Widget _buildUserDetailsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("User Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            const Text("Unlocked", style: TextStyle(fontSize: 16)),
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
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _buildInfoField(
              'First Name',
              _firstNameController,
              keyboardType: TextInputType.name,
            )),
            const SizedBox(width: 20),
            Expanded(
                child: _buildInfoField(
              'Last Name',
              _lastNameController,
              keyboardType: TextInputType.name,
            )),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoField('Email', _emailController,
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 20),
        _buildInfoField('Phone Number', _phoneController,
            keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return SizedBox(
      width: 320,
      height: 48,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        value: selectedRole,
        hint: const Text('Select your user',
            style: TextStyle(color: Colors.grey)),
        items: const ['Administrator', 'User']
            .map((role) => DropdownMenuItem(value: role, child: Text(role)))
            .toList(),
        onChanged: (v) => setState(() => selectedRole = v),
        validator: (v) =>
            (v == null || v.isEmpty) ? 'Please select user type' : null,
        decoration: const InputDecoration(
          filled: true,
          fillColor: AppColors.backgroundColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.blue, width: 3)),
        ),
        dropdownStyleData: const DropdownStyleData(
            offset: Offset(0, 8),
            decoration: BoxDecoration(color: AppColors.white)),
      ),
    );
  }

 Widget _buildSaveButton() {
  return _buildButton('Save', AppColors.blue, () async {
    if ((_formKey.currentState?.validate() ?? false)) {
      final newUser = User(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        status: "",
        role: selectedRole,
      );
      if (!mounted) return; 
      final cubit = context.read<UserCubit>();
      final navigator = Navigator.of(context);
      await cubit.createUser(widget.userToken, newUser);
      if (!mounted) return; 
      navigator.pop(true);
    }
  });
}
  Widget _buildBackButton() {
    return _buildButton('Back', AppColors.blue, () {
      Navigator.pop(context);
    }, icon: null);
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

  Widget _buildButton(String text, Color borderColor, VoidCallback onPressed,
      {Color? backgroundColor, IconData? icon}) {
    return CustomButton(
      label: text,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? Colors.white,
      borderColor: borderColor,
      textColor: backgroundColor != null ? Colors.white : borderColor,
    );
  }
}
