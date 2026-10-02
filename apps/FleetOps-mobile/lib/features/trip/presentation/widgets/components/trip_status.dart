import 'package:flutter/material.dart';
import 'package:core/core.dart';

class TripStatus extends StatelessWidget {
  final String status;

  const TripStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: status == "Selesai" ? AppColors.bgprimary : AppColors.warningbg,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: status == "Selesai" ? AppColors.primary : AppColors.warning,
          fontSize: 12,
        ),
      ),
    );
  }
}
