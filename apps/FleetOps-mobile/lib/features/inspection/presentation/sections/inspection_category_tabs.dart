import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/categories/inspection_categories.dart';

class InspectionCategoryTabs extends StatelessWidget {
  final InspectionCategory selectedCategory;
  final ValueChanged<InspectionCategory> onCategoryChanged;
  final Map<InspectionCategory, int> completedPerCategory;

  const InspectionCategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.completedPerCategory = const {},
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: InspectionCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = InspectionCategory.values[index];
          final isSelected = category == selectedCategory;
          final completed = completedPerCategory[category] ?? 0;
          final total = category.items.length;
          return _CategoryTab(
            category: category,
            isSelected: isSelected,
            completed: completed,
            total: total,
            onTap: () => onCategoryChanged(category),
          );
        },
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final InspectionCategory category;
  final bool isSelected;
  final int completed;
  final int total;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.category,
    required this.isSelected,
    required this.completed,
    required this.total,
    required this.onTap,
  });

  bool get _isDone => completed >= total && total > 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : _isDone
                    ? AppColors.success.withOpacity(0.4)
                    : AppColors.grey300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isDone && !isSelected) ...[
              const Icon(
                Icons.check_circle_rounded,
                size: 13,
                color: AppColors.success,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              category.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.white
                    : _isDone
                        ? AppColors.success
                        : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
