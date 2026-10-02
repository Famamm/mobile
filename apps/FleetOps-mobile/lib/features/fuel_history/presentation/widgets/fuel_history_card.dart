import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../domain/entities/fuel_history_entity.dart';

class FuelHistoryCard extends StatelessWidget {
  final FuelHistoryEntity item;
  final VoidCallback? onTap;

  const FuelHistoryCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DateLabel(date: item.date),
                _StatusBadge(status: item.status),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.vehicleName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.plateNumber,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.borderLight),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bahan Bakar',
                      style: TextStyle(fontSize: 11, color: AppColors.grey400),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.fuelType} (${item.liters.toStringAsFixed(1)} L)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total Biaya',
                      style: TextStyle(fontSize: 11, color: AppColors.grey400),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rp ${_formatCurrency(item.totalCost)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (item.hasReceipt) ...[
              const SizedBox(height: 10),
              const Divider(height: 1, color: AppColors.borderLight),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Icon(Icons.receipt_long_outlined,
                      size: 16, color: AppColors.grey400),
                  SizedBox(width: 6),
                  Text(
                    'Struk terlampir',
                    style: TextStyle(fontSize: 12, color: AppColors.grey400),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right_rounded,
                      size: 18, color: AppColors.primary),
                ],
              ),
            ],
          ],
        ),
      ),
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

class _DateLabel extends StatelessWidget {
  final DateTime date;
  const _DateLabel({required this.date});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${date.day} ${_monthName(date.month)} ${date.year}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          TextSpan(
            text:
                '  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} WIB',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return names[m];
  }
}

class _StatusBadge extends StatelessWidget {
  final FuelHistoryStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, textColor, bgColor) = switch (status) {
      FuelHistoryStatus.selesai => (
          'SELESAI',
          AppColors.successDark,
          AppColors.successLight
        ),
      FuelHistoryStatus.diverifikasi => (
          'DIVERIFIKASI',
          AppColors.primary,
          AppColors.primaryLight
        ),
      FuelHistoryStatus.menunggu => (
          'MENUNGGU',
          AppColors.warning,
          AppColors.warningLight
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
