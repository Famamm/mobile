import 'package:core/core.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final double? borderRadius;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bool isValidValue = value.isEmpty || items.contains(value);
    return DropdownButtonFormField<String>(
      style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
      value: isValidValue ? (value.isEmpty ? null : value) : null,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: AppColors.textPrimary, fontSize: 14),
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          borderSide: BorderSide(
            color: AppColors.grey300,
          ), // Border saat enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ), // Border saat focus
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          borderSide: BorderSide(color: AppColors.error), // Border saat error
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      dropdownColor: AppColors.white,
    );
  }
}
