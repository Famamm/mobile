import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:gap/gap.dart';
import 'package:shared/shared.dart';

class DialogEndConfirmation extends StatelessWidget {
  const DialogEndConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      icon: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_circle_rounded, color: AppColors.primary),
      ),
      title: const Text(
        'Akhiri Perjalanan?',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: const Text(
        'Data perjalanan akan disimpan. Yakin ingin mengakhiri perjalanan?',
        textAlign: TextAlign.center,
      ),
      actions: [
        Column(
          children: [
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Lanjutkan Perjalanan',
              borderColor: AppColors.grey200,
              textColor: AppColors.grey800,
              color: AppColors.grey50,
            ),
            Gap(8.0),
            CustomButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              text: 'Akhiri Perjalanan',
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
