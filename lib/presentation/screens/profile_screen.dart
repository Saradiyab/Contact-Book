import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/custom/footer_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isUnlocked = false;
  bool isEditing = false;

  final firstNameController = TextEditingController(text: "Adam");
  final lastNameController = TextEditingController(text: "Smith");
  final emailController = TextEditingController(text: "adam_smith@email.com");
  final phoneController = TextEditingController(text: "+49 5658 564 613");

  String selectedRole = "Administrator";

  static const List<String> roles = ["Administrator", "User", "Guest"];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: !isEditing,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.backgroundColor,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
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

  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() => isEditing = !isEditing);
      },
      icon: Icon(
        isEditing ? Icons.save : Icons.edit,
        size: 18,
        color: isEditing ? Colors.white : AppColors.blue,
      ),
      label: Text(
        isEditing ? "Save" : "Edit",
        style: TextStyle(
          color: isEditing ? Colors.white : AppColors.blue,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isEditing ? AppColors.blue : Colors.white,
        side: isEditing
            ? null
            : const BorderSide(color: AppColors.blue, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: () {
        setState(() => isEditing = false);
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.blue, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: const Text(
        "Cancel",
        style: TextStyle(color: AppColors.blue, fontSize: 16),
      ),
    );
  }

  Widget _buildUserDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 357, 
      height: 601, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header & Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "User Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: isUnlocked,
                onChanged: (value) {
                  setState(() => isUnlocked = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildTextField("First Name", firstNameController,
                    keyboardType: TextInputType.name),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField("Last Name", lastNameController,
                    keyboardType: TextInputType.name),
              ),
            ],
          ),

          const SizedBox(height: 20),
          _buildTextField("Email", emailController,
              keyboardType: TextInputType.emailAddress),      
              const SizedBox(height: 20),
          _buildTextField("Phone", phoneController,
              keyboardType: TextInputType.phone),
              const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DropdownButtonFormField<String>(
              value: selectedRole,
              onChanged: isEditing
                  ? (String? newValue) {
                      if (newValue != null) {
                        setState(() => selectedRole = newValue);
                      }
                    }
                  : null,
              items: roles
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.backgroundColor,
                labelText: "Role",
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blue, width: 3),
                ),
                floatingLabelStyle: const TextStyle(color: AppColors.blue),
              ),
            ),
          ),
          const SizedBox(height: 35),
          Row(children: [Expanded(child: _buildEditButton())]),
          const SizedBox(height: 25),
          Row(children: [Expanded(child: _buildCancelButton())]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: ''),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Home / Users / Adam Smith",
                style: TextStyle(color: Colors.black, fontSize: 18)),
            const Divider(color: AppColors.lightgrey),
            const SizedBox(height: 10),
            _buildUserDetailsCard(),
            const SizedBox(height: 70),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
