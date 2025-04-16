import 'package:contact_app1/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/data/models/contact.dart';
import 'package:contact_app1/presentation/widgets/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactDetailsScreen extends StatefulWidget {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String imageUrl;
  final String? email2;
  final String? mobile;
  final String? address;
  final String? address2;
  final ContactStatus status;
  final String token;

  const ContactDetailsScreen({
    Key? key,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.imageUrl,
    this.email2,
    this.mobile,
    this.address,
    this.address2,
    required this.status,
    required this.token,
  }) : super(key: key);

  @override
  _ContactDetailsScreenState createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  bool isEditing = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _email2Controller;
  late TextEditingController _mobileController;
  late TextEditingController _addressController;
  late TextEditingController _address2Controller;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _email2Controller = TextEditingController(text: widget.email2 ?? '');
    _mobileController = TextEditingController(text: widget.mobile ?? '');
    _addressController = TextEditingController(text: widget.address ?? '');
    _address2Controller = TextEditingController(text: widget.address2 ?? '');
  }

  void updateContact(BuildContext context) async {
    final updatedContact = Contact(
      id: widget.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      mobileNumber: _mobileController.text,
      status: widget.status,
      imageUrl: widget.imageUrl,
      isFavorite: false,
      address: _addressController.text,
      addressTwo: _address2Controller.text,
    );

    try {
      // mounted kontrolü ile widget aktifse işlemi yapıyoruz
      if (!mounted) return;

      await context.read<ContactCubit>().updateContact(
            id: widget.id,
            contact: updatedContact,
          );

      // İşlem sonrası widget aktifse, UI'yi güncelliyoruz
      if (!mounted) return;
      
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact updated successfully!')),
      );
    } catch (e) {
      // Hata durumunda da mounted kontrolü
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _email2Controller.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _address2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: widget.token),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Home / Contacts / ${widget.firstName} ${widget.lastName}",
                style: const TextStyle(fontSize: 18)),
            const Divider(height: 20),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Contact Details",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Text("Active", style: TextStyle(fontSize: 16)),
                          Switch(
                            value: isEditing,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() => isEditing = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 82.5,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: (widget.imageUrl.isNotEmpty &&
                              widget.imageUrl.toLowerCase() != "null")
                          ? NetworkImage(widget.imageUrl)
                          : const AssetImage('assets/images/nophoto.jpg')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  _buildTextField("Email", _emailController, isEditing),
                  const SizedBox(height: 20),
                  _buildTextField("Phone", _phoneController, isEditing),
                  const SizedBox(height: 20),
                  _buildTextField("Email 2", _email2Controller, isEditing),
                  const SizedBox(height: 20),
                  _buildTextField("Mobile", _mobileController, isEditing),
                  const SizedBox(height: 20),
                  _buildTextField("Address", _addressController, isEditing),
                  const SizedBox(height: 20),
                  _buildTextField("Address 2", _address2Controller, isEditing),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      _buildButton(
                        isEditing ? "Save" : "Edit",
                        isEditing ? Colors.white : AppColors.blue,
                        () {
                          if (isEditing) {
                            updateContact(context);
                          }
                          if (mounted) {
                            setState(() => isEditing = !isEditing);
                          }
                        },
                        isEditing,
                        icon: isEditing ? null : Icons.edit,
                      ),
                      const SizedBox(height: 20),
                      _buildButton("Back", AppColors.blue,
                          () => Navigator.pop(context), false),
                    ],
                  )
                ],
              ),
            ),
            const FooterWidget()
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
