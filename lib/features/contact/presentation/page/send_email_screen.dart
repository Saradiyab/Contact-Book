import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:contact_app1/features/contact/data/models/send_email.dart';
import 'package:contact_app1/features/contact/presentation/bloc/conatct_cubit.dart';
import 'package:contact_app1/features/contact/presentation/bloc/contact_state.dart';
import 'package:contact_app1/core/widgets/custom_drawer.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/custom_appbar.dart';

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
        if (trimmed.isEmpty) return AppStrings.recipientEmailRequired.tr();
        if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(trimmed)) {
          return AppStrings.invalidEmail.tr();
        }
        break;
      case 'Subject':
      if (trimmed.isEmpty) return AppStrings.subjectEmpty.tr();
        break;
      case 'Message':
      if (trimmed.isEmpty) return AppStrings.messageEmpty.tr();
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
          labelText: label.tr(),
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
          text.tr(),
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
                SnackBar(content: Text(state.message.tr())),
              );
            } else if (state is ContactError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message.tr()),
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
                  Text(
                    "Home / Contacts / Send Email".tr(),
                    style: const TextStyle(fontSize: 18),
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
                        _buildTextField(AppStrings.to, _toController),
                        _buildTextField(AppStrings.cc, _ccController),
                        _buildTextField(AppStrings.bcc, _bccController),
                        _buildTextField(AppStrings.subject, _subjectController),
                        _buildTextField(AppStrings.message, _bodyController,
                            maxLines: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          AppStrings.discard,
                          Colors.white,
                          () {},
                          backgroundColor: AppColors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildButton(
                          AppStrings.send,
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
