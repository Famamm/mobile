import 'package:flutter/material.dart';
import 'package:core/core.dart';

class TotalBiayaField extends StatelessWidget {
  final int? selectedFuelPricePerLiter;
  final String jmlLiterText;
  final double totalBiaya;

  const TotalBiayaField({
    Key? key,
    required this.selectedFuelPricePerLiter,
    required this.jmlLiterText,
    required this.totalBiaya,
  }) : super(key: key);

  String _formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValidData =
        selectedFuelPricePerLiter != null && jmlLiterText.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        hasValidData
            ? _formatRupiah(totalBiaya)
            : 'Total Biaya Isi Otomatis',
        style: TextStyle(
          fontSize: 14,
          color: hasValidData
              ? AppColors.textPrimary
              : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
