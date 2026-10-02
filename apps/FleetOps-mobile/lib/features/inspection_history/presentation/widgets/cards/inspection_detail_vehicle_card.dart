import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/features/inspection_history/domain/entities/inspection_history_detail_entity.dart';
import 'package:fleetops_mobile/features/inspection_history/presentation/widgets/badges/inspection_status_badge.dart';

class InspectionDetailVehicleCard extends StatelessWidget {
  final InspectionHistoryDetailEntity detail;
  const InspectionDetailVehicleCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  detail.vehicleName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InspectionStatusBadge(status: detail.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            detail.plateNumber,
            style:
                const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 16, color: AppColors.grey400),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TANGGAL',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.grey400,
                          fontWeight: FontWeight.w600)),
                  Text(
                    '${detail.date.day} ${_monthName(detail.date.month)} ${detail.date.year}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              const Icon(Icons.access_time_rounded,
                  size: 16, color: AppColors.grey400),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('WAKTU',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.grey400,
                          fontWeight: FontWeight.w600)),
                  Text(
                    '${detail.date.hour.toString().padLeft(2, '0')}:${detail.date.minute.toString().padLeft(2, '0')} WIB',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
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
