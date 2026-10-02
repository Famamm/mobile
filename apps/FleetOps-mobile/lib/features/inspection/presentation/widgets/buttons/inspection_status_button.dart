import 'package:flutter/material.dart';
import 'package:core/core.dart';

// ── Shared status enum used across the inspection feature ──────────────────
enum InspectionStatus { none, ok, notOk }

class InspectionStatusButton extends StatelessWidget {
  final InspectionStatus status;
  final VoidCallback onCatatan;
  final VoidCallback onNotOk;
  final VoidCallback onOk;

  const InspectionStatusButton({
    super.key,
    required this.status,
    required this.onCatatan,
    required this.onNotOk,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CatatanButton(onTap: onCatatan),
        const SizedBox(width: 8),
        _NotOkButton(
          isSelected: status == InspectionStatus.notOk,
          onTap: onNotOk,
        ),
        const SizedBox(width: 8),
        _OkButton(isSelected: status == InspectionStatus.ok, onTap: onOk),
      ],
    );
  }
}

// ── Catatan (Notes) button ─────────────────────────────────────────────────
class _CatatanButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CatatanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      label: 'Catatan',
      onTap: onTap,
      backgroundColor: AppColors.grey100,
      foregroundColor: AppColors.textSecondary,
      borderColor: AppColors.grey100,
    );
  }
}

// ── Tidak OK button ────────────────────────────────────────────────────────
class _NotOkButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  const _NotOkButton({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      label: 'Tidak OK',
      onTap: onTap,
      backgroundColor: isSelected ? AppColors.error : AppColors.grey100,
      foregroundColor: isSelected ? AppColors.white : AppColors.textSecondary,
      borderColor: isSelected ? AppColors.error : AppColors.grey100,
      bold: true,
    );
  }
}

// ── OK button ──────────────────────────────────────────────────────────────
class _OkButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  const _OkButton({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      label: 'OK',
      onTap: onTap,
      backgroundColor: isSelected ? AppColors.success : AppColors.grey100,
      foregroundColor: isSelected ? AppColors.white : AppColors.textSecondary,
      borderColor: isSelected ? AppColors.success : AppColors.grey100,
      horizontalPadding: 20,
      bold: true,
    );
  }
}

// ── Shared base button ─────────────────────────────────────────────────────
class _BaseButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double horizontalPadding;
  final bool bold;

  const _BaseButton({
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    this.horizontalPadding = 12,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}
