import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../domain/entities/statistic_entity.dart';

class OperationalSummary extends StatelessWidget {
  final StatisticEntity statistic;

  const OperationalSummary({super.key, required this.statistic});

  String _formatNumber(int value) {
    final text = value.toString();
    return text.replaceAllMapped(
      RegExp(r'(?<!^)(?=(\d{3})+$)'),
      (match) => '.',
    );
  }

  String _formatDecimal(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCardForm(
      title: 'Ringkasan Operasional',
      formFields: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OperationalRow(
              icon: Icons.route_outlined,
              label: 'Total Jarak',
              value: '${_formatDecimal(statistic.totalDistance)} km',
            ),
            _OperationalRow(
              icon: Icons.local_gas_station_outlined,
              label: 'Total BBM',
              value: '${_formatDecimal(statistic.totalFuel)} liter',
              // detail: statistic.fuelTypes.isEmpty
              //     ? null
              //     : statistic.fuelTypes.join(', '),
            ),
            _OperationalRow(
              icon: Icons.payments_outlined,
              label: 'Total Harga',
              value: 'Rp ${_formatNumber(statistic.totalCost)}',
              valueColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}

class _OperationalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? detail;
  final Color? valueColor;

  const _OperationalRow({
    required this.icon,
    required this.label,
    required this.value,
    this.detail,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.bgprimary,
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
              if (detail != null)
                Text(
                  detail!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
