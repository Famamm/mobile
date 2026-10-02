import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../domain/entities/daily_activity_entity.dart';

class ActivityChart extends StatelessWidget {
  final List<DailyActivityEntity> activity;
  final int totalTrips;

  const ActivityChart({
    super.key,
    required this.activity,
    required this.totalTrips,
  });

  @override
  Widget build(BuildContext context) {
    final maximum = activity.fold<int>(
      0,
      (max, item) => item.tripCount > max ? item.tripCount : max,
    );

    return CustomCardForm(
      title: 'Aktivitas Armada',
      formFields: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '7 Hari Terakhir',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Puncak: ${maximum} perjalanan',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 170,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: activity.map((item) {
                  final isPeak = item.tripCount == maximum;
                  final height = maximum == 0
                      ? 0.0
                      : item.tripCount / maximum * 120;
                  return _ActivityBar(
                    item: item,
                    height: height,
                    isPeak: isPeak,
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 28, color: AppColors.grey200),
            const Text(
              'Total Perjalanan',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '$totalTrips perjalanan',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActivityBar extends StatelessWidget {
  final DailyActivityEntity item;
  final double height;
  final bool isPeak;

  const _ActivityBar({
    required this.item,
    required this.height,
    required this.isPeak,
  });

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 22,
          child: Text(
            '${item.tripCount}',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: 28,
          height: height,
          decoration: BoxDecoration(
            color: isPeak
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.22),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          weekdays[item.date.weekday - 1],
          style: TextStyle(
            color: isPeak ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isPeak ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
