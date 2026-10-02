import 'package:flutter/material.dart';
import 'package:core/core.dart';

class InspectionChecklistHeader extends StatelessWidget {
  final String categoryName;
  final int totalItems;
  final int completedItems;

  const InspectionChecklistHeader({
    super.key,
    required this.categoryName,
    required this.totalItems,
    required this.completedItems,
  });

  bool get _isComplete => totalItems > 0 && completedItems >= totalItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$completedItems dari $totalItems item selesai',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildBadge(),
      ],
    );
  }

  Widget _buildBadge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _isComplete
            ? AppColors.success
            : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _isComplete ? 'Selesai' : 'Dalam Proses',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _isComplete ? AppColors.white : AppColors.primary,
        ),
      ),
    );
  }
}
