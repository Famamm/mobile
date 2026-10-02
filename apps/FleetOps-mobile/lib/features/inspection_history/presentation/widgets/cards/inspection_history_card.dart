import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../../domain/entities/inspection_history_entity.dart';

class InspectionHistoryCard extends StatelessWidget {
  final InspectionHistoryEntity item;
  final VoidCallback? onTap;

  const InspectionHistoryCard({
    super.key,
    required this.item,
    this.onTap,
  });

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date + status badge row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _DateLabel(date: item.date),
                      _StatusBadge(status: item.status),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Vehicle name + progress row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.vehicleName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.plateNumber,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _ProgressLabel(percent: item.progressPercent),
                    ],
                  ),
                ],
              ),
            ),

            // Problem banner (only when ada masalah)
            if (item.hasProblem) ...[
              const Divider(height: 1, color: AppColors.errorLight),
              ...item.problems
                  .map((p) => _ProblemBanner(description: p.description)),
            ],
          ],
        ),
      ),
    );
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

  String _monthName(int month) {
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
      'Des',
    ];
    return names[month];
  }
}

class _StatusBadge extends StatelessWidget {
  final InspectionHistoryStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, textColor, bgColor) = switch (status) {
      InspectionHistoryStatus.selesai => (
          'SELESAI',
          AppColors.successDark,
          AppColors.successLight,
        ),
      InspectionHistoryStatus.adaMasalah => (
          'ADA MASALAH',
          AppColors.warning,
          AppColors.warningLight,
        ),
      InspectionHistoryStatus.diProses => (
          'DI PROSES',
          AppColors.primary,
          AppColors.primaryLight,
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

class _ProgressLabel extends StatelessWidget {
  final int percent;

  const _ProgressLabel({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Progres',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$percent%',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.primary,
          size: 20,
        ),
      ],
    );
  }
}

class _ProblemBanner extends StatelessWidget {
  final String description;

  const _ProblemBanner({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.warning_rounded,
              color: AppColors.error,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
