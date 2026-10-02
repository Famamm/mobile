import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:gap/gap.dart';
import 'package:shared/shared.dart';

class DialogExitConfirmation extends StatelessWidget {
  final int tripId;
  final int driverId;
  final VoidCallback onCancelTrip;

  const DialogExitConfirmation({
    super.key,
    required this.tripId,
    required this.driverId,
    required this.onCancelTrip,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      icon: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.warning_amber_rounded, color: AppColors.warning),
      ),
      title: const Text(
        'Batalkan Perjalanan?',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: const Text(
        'Jika Anda keluar sekarang, data perjalanan tidak akan disimpan. '
        'Yakin ingin membatalkan?',
        textAlign: TextAlign.center,
      ),
      actions: [
        Column(
          children: [
            CustomButton(
              onPressed: () => Navigator.pop(context),
              text: 'Lanjutkan Perjalanan',
              color: AppColors.warning,
            ),
            Gap(8.0),
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                onCancelTrip();
              },
              text: 'Batalkan',
              borderColor: AppColors.grey200,
              textColor: AppColors.grey800,
              color: AppColors.grey50,
            ),
          ],
        ),
      ],
    );
  }
}
