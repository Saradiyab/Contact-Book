import 'dart:io';
import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/data/models/contact.dart';
import 'package:contact_app1/presentation/widgets/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact_app1/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/presentation/screens/contact/contacts_screen.dart';

class CreateContactScreen extends StatefulWidget {
  final String userToken;
  final Contact? contact;  

  const CreateContactScreen({Key? key, required this.userToken, this.contact}) : super(key: key);

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
  bool isEditing = true;

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
        image: _selectedImage != null ? _selectedImage!.path : null, 
        address: _addressController.text,
        isFavorite: false,
        status: selectedStatus != null ? ContactStatus.fromString(selectedStatus) : null,
        emailTwo: _email2Controller.text,
        addressTwo: _address2Controller.text,
        companyId: _companyIdController.text.isNotEmpty ? int.tryParse(_companyIdController.text) : null,
      );

      context.read<ContactCubit>().createContact(contact: newContact, image: _selectedImage);
      print("Create response: ${newContact.toJson()}");

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact created successfully!')));
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
              const Text("Home / Contacts / Create New", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Contact Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
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
                    const Text("JPG or PNG no larger than 5MB", style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400)),
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
                        child: const Text("Upload new image", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildTextField("First Name", _firstNameController, isEditing)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildTextField("Last Name", _lastNameController, isEditing)),
                            ],
                          ),
                          _buildTextField("Email 1", _emailController, isEditing),
                          _buildTextField("Phone *", _phoneController, isEditing),
                          _buildTextField("Email 2", _email2Controller, isEditing),
                          _buildTextField("Mobile", _mobileController, isEditing),
                          _buildTextField("Address", _addressController, isEditing),
                          _buildTextField("Address 2", _address2Controller, isEditing),
                          const SizedBox(height: 20),
                          _buildButton("Create", AppColors.blue, _submitForm, backgroundColor: AppColors.blue),
                          const SizedBox(height: 10),
                          _buildButton("Back", AppColors.blue, () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactsScreen(userToken: widget.userToken),
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isEditing) {
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
        validator: label.contains("Phone")
            ? (value) => value == null || value.isEmpty ? "Phone is required" : null
            : null,
      ),
    );
  }

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
