import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/chips/progress_info_chip.dart';

class InspectionProgressSection extends StatelessWidget {
  final int totalItems;
  final int completedItems;
  final String vehicleId;
  final String inspectionType;

  const InspectionProgressSection({
    super.key,
    required this.totalItems,
    required this.completedItems,
    required this.vehicleId,
    this.inspectionType = 'Inspeksi Harian',
  });

  double get _progress => totalItems > 0 ? completedItems / totalItems : 0.0;
  int get _percentage => (_progress * 100).round();
  int get _remaining => totalItems - completedItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.grey100,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(),
          const SizedBox(height: 14),
          _buildProgressBar(),
          const SizedBox(height: 12),
          _buildChipRow(),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTitleBlock()),
        const SizedBox(width: 12),
        _buildPercentageBlock(),
      ],
    );
  }

  Widget _buildTitleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          inspectionType,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            const Icon(
              Icons.directions_car_outlined,
              size: 13,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Vehicle ID: $vehicleId',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPercentageBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$_percentage%',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Complete',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: _progress,
        minHeight: 8,
        backgroundColor: AppColors.grey200,
        valueColor: AlwaysStoppedAnimation<Color>(
          _percentage == 100 ? AppColors.success : AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildChipRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ProgressInfoChip(
          value: '$completedItems',
          label: 'Selesai',
          color: AppColors.success,
        ),
        ProgressInfoChip(
          value: '$_remaining',
          label: 'Tersisa',
          color: AppColors.warning,
        ),
        ProgressInfoChip(
          value: '$totalItems',
          label: 'Total',
          color: AppColors.primary,
        ),
      ],
    );
  }
}
