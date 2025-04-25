import 'package:contact_app1/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/business_logic/cubit/contact_state.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/data/models/contact.dart';
import 'package:contact_app1/data/models/send_email.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/custom/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendEmailScreen extends StatefulWidget {
  const SendEmailScreen({super.key, required List<Contact> contacts});

  @override
  State<SendEmailScreen> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  final _toController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _toController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _sendEmail() {
    if (_formKey.currentState!.validate()) {
      final email = EmailModel(
        to: _toController.text.trim(),
        cc: _ccController.text.trim(),
        bcc: _bccController.text.trim(),
        subject: _subjectController.text.trim(),
        body: _bodyController.text.trim(),
      );

      context.read<ContactCubit>().sendEmail(email);
    }
  }

  String? _validateField(String value, String label) {
    final trimmed = value.trim();

    switch (label) {
      case 'To':
        if (trimmed.isEmpty) return 'Recipient email address is required';
        if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(trimmed)) {
          return 'Please enter a valid email address';
        }
        break;
      case 'Subject':
        if (trimmed.isEmpty) return 'Subject cannot be left blank';
        break;
      case 'Message':
        if (trimmed.isEmpty) return 'Message content cannot be left blank';
        break;
    }
    return null;
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
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
        validator: (value) => _validateField(value ?? '', label),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color textColor,
    VoidCallback onPressed, {
    Color? backgroundColor,
  }) {
    return SizedBox(
      width: 171,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      drawer: const CustomDrawer(token: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ContactCubit, ContactState>(
          listener: (context, state) {
            if (state is ContactsEmailSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ContactError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ContactLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Home / Contacts / Send Email",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('To', _toController),
                        _buildTextField('CC', _ccController),
                        _buildTextField('BCC', _bccController),
                        _buildTextField('Subject', _subjectController),
                        _buildTextField('Message', _bodyController,
                            maxLines: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          "Discard",
                          Colors.white,
                          () {},
                          backgroundColor: AppColors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildButton(
                          "Send",
                          Colors.white,
                          _sendEmail,
                          backgroundColor: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  const FooterWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
