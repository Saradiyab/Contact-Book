import 'dart:io';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/features/contact/data/models/contact_status_extension.dart';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:contact_app1/features/contact/presentation/bloc/conatct_cubit.dart';
import 'package:contact_app1/features/contact/presentation/page/contacts_screen.dart';
import 'package:contact_app1/core/widgets/custom_appbar.dart';
import 'package:contact_app1/core/widgets/custom_button.dart';
import 'package:contact_app1/core/widgets/custom_textfield.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateContactScreen extends StatefulWidget {
  final String userToken;
  final Contact? contact;

  const CreateContactScreen({super.key, required this.userToken, this.contact});

  @override
  State<CreateContactScreen> createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _email2Controller = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _companyIdController = TextEditingController();
  String? selectedStatus;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      _firstNameController.text = widget.contact?.firstName ?? '';
      _lastNameController.text = widget.contact?.lastName ?? '';
      _emailController.text = widget.contact?.email ?? '';
      _phoneController.text = widget.contact?.phoneNumber ?? '';
      _email2Controller.text = widget.contact?.emailTwo ?? '';
      _mobileController.text = widget.contact?.mobileNumber ?? '';
      _addressController.text = widget.contact?.address ?? '';
      _address2Controller.text = widget.contact?.addressTwo ?? '';
      _companyIdController.text = widget.contact?.companyId?.toString() ?? '';
      selectedStatus = widget.contact?.status?.name;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newContact = Contact(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        mobileNumber: _mobileController.text.isNotEmpty ? _mobileController.text : null,
        image: _selectedImage?.path,
        address: _addressController.text,
        isFavorite: false,
        status: selectedStatus?.toContactStatus(),
        emailTwo: _email2Controller.text,
        addressTwo: _address2Controller.text,
        companyId: _companyIdController.text.isNotEmpty ? int.tryParse(_companyIdController.text) : null,
      );

      context.read<ContactCubit>().createContact(contact: newContact, image: _selectedImage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.contactCreatedSuccess.tr())),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ContactsScreen(userToken: widget.userToken)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Home / Contacts / Create New".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              const Divider(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.contactDetails.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 82.5,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : const AssetImage("assets/images/nophoto.jpg") as ImageProvider,
                    ),
                    const SizedBox(height: 8),
                    Text(AppStrings.imageExtensionValidation.tr(), style: const TextStyle(color: Colors.grey, fontSize: 18)),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 322,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        onPressed: _pickImage,
                        child: Text(AppStrings.uploadNewImage.tr(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildInfoField(AppStrings.firstName.tr(), _firstNameController, keyboardType: TextInputType.name)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildInfoField(AppStrings.lastName.tr(), _lastNameController, keyboardType: TextInputType.name)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildInfoField(AppStrings.email1.tr(), _emailController, keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 10),
                          _buildInfoField(AppStrings.phonestar.tr(), _phoneController, keyboardType: TextInputType.phone),
                          const SizedBox(height: 10),
                          _buildInfoField(AppStrings.email2.tr(), _email2Controller, keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 10),
                          _buildInfoField(AppStrings.mobile.tr(), _mobileController, keyboardType: TextInputType.number),
                          const SizedBox(height: 10),
                          _buildInfoField(AppStrings.address.tr(), _addressController, keyboardType: TextInputType.text),
                          const SizedBox(height: 10),
                          _buildInfoField(AppStrings.address2.tr(), _address2Controller, keyboardType: TextInputType.text),
                          const SizedBox(height: 20),
                          _buildButton(AppStrings.save.tr(), AppColors.blue, _submitForm, backgroundColor: AppColors.blue),
                          const SizedBox(height: 10),
                          _buildButton(AppStrings.back.tr(), AppColors.blue, () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ContactsScreen(userToken: widget.userToken)),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomTextField(
        controller: controller,
        hintText: label,
        keyboardType: keyboardType,
        readOnly: false,
      ),
    );
  }

  Widget _buildButton(String text, Color borderColor, VoidCallback onPressed, {Color? backgroundColor, IconData? icon}) {
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
