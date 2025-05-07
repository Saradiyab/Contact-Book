import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';

class UserBuildButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final VoidCallback onPressed;
  final Widget? child;
  final Color? backgroundColor;

  const UserBuildButton({
    super.key,
    required this.text,
    required this.borderColor,
    required this.onPressed,
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: backgroundColor ?? AppColors.white,
          backgroundColor: backgroundColor ?? AppColors.white,
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
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
