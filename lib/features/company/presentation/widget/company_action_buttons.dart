import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:easy_localization/easy_localization.dart'; // <-- Bunu da unutma

class CompanyActionButtons extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onSaveOrEdit;
  final VoidCallback onBack;

  const CompanyActionButtons({
    super.key,
    required this.isEditing,
    required this.onSaveOrEdit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildButton(
          isEditing ? AppStrings.save.tr() : AppStrings.edit.tr(),
          isEditing ? AppColors.blue : Colors.white,
          onSaveOrEdit,
          borderColor: AppColors.blue,
          textColor: isEditing ? Colors.white : AppColors.blue,
          icon: isEditing ? null : Icons.edit,
        ),
        const SizedBox(height: 10),
        _buildButton(
          AppStrings.back.tr(),
          Colors.white,
          onBack,
          borderColor: AppColors.blue,
          textColor: AppColors.blue,
        ),
      ],
    );
  }

  Widget _buildButton(
    String text,
    Color bgColor,
    VoidCallback onPressed, {
    required Color borderColor,
    required Color textColor,
    IconData? icon,
  }) {
    return SizedBox(
      width: 325,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
