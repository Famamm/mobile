import 'package:flutter/material.dart';
import 'package:core/core.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.borderColor,
    this.onPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: color ?? AppColors.primary,
      shadowColor: AppColors.white,
      elevation: 0,
      minimumSize: Size.fromHeight(50),
      side: BorderSide(color: borderColor ?? Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      overlayColor: AppColors.grey300,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius!,
      ),
    );
    final label =
        Text(text, style: TextStyle(color: textColor ?? AppColors.white));

    if (isLoading) {
      return ElevatedButton(
        style: style,
        onPressed: null,
        child: Text(
          'Loading...',
          style: TextStyle(color: textColor ?? AppColors.white),
        ),
      );
    }

    if (icon == null) {
      return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: label,
      );
    }
    return ElevatedButton.icon(
      style: style,
      onPressed: onPressed,
      icon: Icon(icon, color: textColor ?? AppColors.white),
      label: label,
    );
  }
}
