import 'package:flutter/material.dart';
import 'package:core/core.dart';

class InspectionProblemNoteField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const InspectionProblemNoteField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 3,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(), const SizedBox(height: 8), _buildTextField()],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'CATATAN MASALAH',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.error,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      decoration: InputDecoration(
        hintText: hintText ?? 'Jelaskan masalah yang terjadi...',
        hintStyle: TextStyle(
          fontSize: 13,
          color: AppColors.grey500,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.errorLight, width: 1.5),
        ),
      ),
    );
  }
}
