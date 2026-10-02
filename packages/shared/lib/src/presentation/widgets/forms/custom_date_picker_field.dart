import 'package:flutter/material.dart';
import 'package:core/core.dart';

class CustomDatePickerField extends StatelessWidget {
  final String? value;
  final ValueChanged<DateTime> onDateSelected;
  final String hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String Function(DateTime)? formatter;
  final double borderRadius;
  final String? Function(String?)? validator;

  const CustomDatePickerField({
    super.key,
    required this.onDateSelected,
    this.value,
    this.hintText = 'DD/MM/YYYY',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.formatter,
    this.borderRadius = 8,
    this.validator,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now.add(const Duration(days: 365)),
      firstDate: firstDate ?? now,
      lastDate: lastDate ?? DateTime(2040),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? hintText,
                  style: TextStyle(
                    color: value != null
                        ? AppColors.black
                        : AppColors.grey500,
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.grey600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}