import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../domain/entities/fuel_history_summary_entity.dart';

class FuelSummaryCard extends StatelessWidget {
  final FuelHistorySummaryEntity summary;

  const FuelSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryItem(
            label: 'Total Pengisian',
            value: 'Rp ${_formatCurrency(summary.totalBiaya)}',
            sub:
                '${summary.totalBiayaChangePercent >= 0 ? '+' : ''}${summary.totalBiayaChangePercent.toStringAsFixed(0)}% vs last month',
            subColor: summary.totalBiayaChangePercent >= 0
                ? AppColors.success
                : AppColors.error,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryItem(
            label: 'Rata-rata Konsumsi',
            value: '${summary.rataRataKonsumsi.toStringAsFixed(1)} KM/L',
            sub: summary.isOptimalRange ? 'Optimal Range' : 'Perlu Perhatian',
            subColor:
                summary.isOptimalRange ? AppColors.primary : AppColors.warning,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    final str = value.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color subColor;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.sub,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(
                fontSize: 11, color: subColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
