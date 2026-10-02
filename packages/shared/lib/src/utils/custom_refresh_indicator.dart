import 'package:flutter/material.dart';
import 'package:core/core.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? spinnerColor;
  final Color? backgroundColor;

  const CustomRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.spinnerColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: spinnerColor ?? AppColors.primary,
      backgroundColor: backgroundColor ?? Colors.white,
      strokeWidth: 3.0,
      elevation: 0,
      displacement: 40.0,
      child: child,
    );
  }
}
