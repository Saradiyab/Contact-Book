import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';

// Buton Widget'i
class ButtonWidget extends StatelessWidget {
  final String text;
  final Color borderColor;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Widget? child;
  final double width;
  final double height;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.borderColor,
    required this.onPressed,
    this.backgroundColor,
    this.child,
    this.width = 325 , 
    this.height = 48, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: backgroundColor ?? AppColors.white,
          backgroundColor: backgroundColor ?? AppColors.white,
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

// PopupButton Widget'i
class PopupButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const PopupButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.blue,
          side: const BorderSide(color: AppColors.blue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
