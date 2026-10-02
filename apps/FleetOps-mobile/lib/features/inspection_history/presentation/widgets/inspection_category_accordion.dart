import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'package:fleetops_mobile/features/inspection_history/domain/entities/inspection_history_detail_entity.dart';

class InspectionCategoryAccordion extends StatefulWidget {
  final InspectionCategoryEntity category;
  const InspectionCategoryAccordion({super.key, required this.category});

  @override
  State<InspectionCategoryAccordion> createState() =>
      _InspectionCategoryAccordionState();
}

class _InspectionCategoryAccordionState
    extends State<InspectionCategoryAccordion> {
  bool _expanded = true;

  IconData get _icon {
    return switch (widget.category.iconAsset) {
      'eksterior' => Icons.directions_car_outlined,
      'interior' => Icons.airline_seat_recline_normal_outlined,
      'mesin' => Icons.settings_outlined,
      'kelengkapan' => Icons.checklist_outlined,
      _ => Icons.fact_check_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(_icon, size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.category.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            ...widget.category.items.map(
              (item) => _CheckItemRow(
                item: item,
                isLast: item == widget.category.items.last,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CheckItemRow extends StatelessWidget {
  final InspectionCheckItemEntity item;
  final bool isLast;
  const _CheckItemRow({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = switch (item.status) {
      'OK' => (AppColors.successLight, AppColors.successDark),
      'MASALAH' => (AppColors.errorLight, AppColors.error),
      _ => (AppColors.grey100, AppColors.grey500),
    };

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, isLast ? 14 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textPrimary)),
                    if (item.note != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Catatan: ${item.note!}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) ...[
          const SizedBox(height: 8),
          const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.borderLight),
        ],
      ],
    );
  }
}
