import 'package:flutter/material.dart';
import 'package:core/core.dart';

class PeriodSelector extends StatelessWidget {
  final DateTime selectedPeriod;
  final ValueChanged<DateTime> onChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  static const _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  Future<void> _selectPeriod(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedPeriod,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onChanged(DateTime(picked.year, picked.month));
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _monthNames[selectedPeriod.month - 1];
    final daysInMonth = DateUtils.getDaysInMonth(
      selectedPeriod.year,
      selectedPeriod.month,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _selectPeriod(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              monthName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Spacer(),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.grey400),
            Text(
              '1-$daysInMonth $monthName',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
