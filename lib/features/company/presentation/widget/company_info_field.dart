import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:easy_localization/easy_localization.dart'; // <-- eklendi

class CompanyInfoField extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController streetOneController;
  final TextEditingController streetTwoController;
  final TextEditingController vatNumberController;
  final TextEditingController zipController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final bool isEditing;

  const CompanyInfoField({
    super.key,
    required this.companyNameController,
    required this.streetOneController,
    required this.streetTwoController,
    required this.vatNumberController,
    required this.zipController,
    required this.cityController,
    required this.stateController,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoField(AppStrings.companyName.tr(), companyNameController),
        _buildGrid([
          _buildInfoField(AppStrings.street.tr(), streetOneController),
          _buildInfoField(AppStrings.street2.tr(), streetTwoController),
        ]),
        _buildGrid([
          _buildInfoField(AppStrings.vatNumber.tr(), vatNumberController),
          _buildInfoField(AppStrings.zip.tr(), zipController),
        ]),
        _buildGrid([
          _buildInfoField(AppStrings.city.tr(), cityController),
          _buildInfoField(AppStrings.state.tr(), stateController),
        ]),
      ],
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          readOnly: !isEditing,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundColor,
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.blue, width: 2),
            ),
            floatingLabelStyle: const TextStyle(color: AppColors.blue),
          ),
          cursorColor: AppColors.blue,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildGrid(List<Widget> children) {
    return Row(
      children: children
          .map((widget) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: widget,
                ),
              ))
          .toList(),
    );
  }
}
