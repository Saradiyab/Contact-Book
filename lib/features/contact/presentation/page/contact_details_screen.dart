import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/core/utils/fetch_image_helper.dart';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:contact_app1/features/contact/presentation/bloc/conatct_cubit.dart';
import 'package:contact_app1/core/widgets/custom_appbar.dart';
import 'package:contact_app1/core/widgets/custom_button.dart';
import 'package:contact_app1/core/widgets/custom_drawer.dart';
import 'package:contact_app1/core/widgets/custom_textfield.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
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
    super.key,
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
  });

  @override
  ContactDetailsScreenState createState() => ContactDetailsScreenState();
}

class ContactDetailsScreenState extends State<ContactDetailsScreen> {
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

  void _onUpdateUser() {
    updateContact();
  }

  Future<void> updateContact() async {
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
      await context.read<ContactCubit>().updateContact(
            id: widget.id,
            contact: updatedContact,
          );

      if (!mounted) return;

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.contactUpdateSuccess.tr())),
      );
    } catch (e) {
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
            Text(
              "${AppStrings.homeContacts.tr()} ${widget.firstName} ${widget.lastName}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
                      Text(
                        AppStrings.contactDetails.tr(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(AppStrings.active.tr(),
                              style: TextStyle(fontSize: 16)),
                          Switch(
                            value: isEditing,
                            onChanged: (value) {
                              setState(() => isEditing = value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                Center(
  child: FutureBuilder<ImageProvider>(
    future: fetchImage(widget.imageUrl, widget.token),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircleAvatar(
          radius: 82.5,
          backgroundColor: Colors.grey,
        );
      } else if (snapshot.hasError || snapshot.data == null) {
        return const CircleAvatar(
          radius: 82.5,
          backgroundImage: AssetImage('assets/images/nophoto.jpg'),
        );
      } else {
        return CircleAvatar(
          radius: 82.5,
          backgroundImage: snapshot.data!,
        );
      }
    },
  ),
),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoField(
                          AppStrings.firstName.tr(),
                          _firstNameController,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoField(
                          AppStrings.lastName.tr(),
                          _lastNameController,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoField(
                    AppStrings.email.tr(),
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoField(
                    AppStrings.phone.tr(),
                    _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoField(
                    AppStrings.email2.tr(),
                    _email2Controller,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoField(
                    AppStrings.mobile.tr(),
                    _mobileController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoField(
                    AppStrings.address.tr(),
                    _addressController,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoField(
                    AppStrings.address2.tr(),
                    _address2Controller,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  _buildButtons(),
                ],
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomTextField(
        controller: controller,
        hintText: label,
        keyboardType: keyboardType,
        readOnly: !isEditing,
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color borderColor,
    VoidCallback onPressed, {
    Color? backgroundColor,
    IconData? icon,
    Color? textColor,
  }) {
    return CustomButton(
      label: text,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? Colors.white,
      borderColor: borderColor,
      textColor: textColor ?? borderColor,
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
}
