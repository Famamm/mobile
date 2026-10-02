import 'package:flutter/material.dart';
import 'package:core/core.dart';

class FuelLocationCard extends StatelessWidget {
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRefresh;

  const FuelLocationCard({
    Key? key,
    this.address,
    this.latitude,
    this.longitude,
    this.isLoading = false,
    this.errorMessage,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.bgprimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'LOKASI PENGISIAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                InkWell(
                  onTap: onRefresh,
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.refresh,
                        size: 18, color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const Text(
              'Mendeteksi lokasi...',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            )
          else if (errorMessage != null)
            Text(
              errorMessage!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            )
          else if (address != null) ...[
            Text(
              address!,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (latitude != null && longitude != null) ...[
              const SizedBox(height: 4),
              Text(
                'Lat: ${latitude!.toStringAsFixed(6)}, '
                'Lng: ${longitude!.toStringAsFixed(6)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ] else
            const Text(
              'Lokasi belum terdeteksi',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
        ],
      ),
    );
  }
}