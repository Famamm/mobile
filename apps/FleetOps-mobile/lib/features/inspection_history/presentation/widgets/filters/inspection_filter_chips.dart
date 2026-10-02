import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../../domain/entities/inspection_history_entity.dart';

class InspectionFilterChips extends StatelessWidget {
  final InspectionHistoryStatus? selected;
  final ValueChanged<InspectionHistoryStatus?> onChanged;

  const InspectionFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _filters = [
    (label: 'Semua', value: null),
    (label: 'Selesai', value: InspectionHistoryStatus.selesai),
    (label: 'Ada Masalah', value: InspectionHistoryStatus.adaMasalah),
    (label: 'Di Proses', value: InspectionHistoryStatus.diProses),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final filter = _filters[i];
          final isSelected = selected == filter.value;
          return GestureDetector(
            onTap: () => onChanged(filter.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                ),
              ),
              child: Text(
                filter.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.white : AppColors.grey500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
