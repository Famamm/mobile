import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          text: 'Masuk ke Akun',
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Divider(color: AppColors.grey300, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'atau',
                style: TextStyle(color: AppColors.grey400),
              ),
            ),
            Expanded(
              child: Divider(color: AppColors.grey300, thickness: 1),
            ),
          ],
        ),
        SizedBox(height: 12),
        CustomButton(
          onPressed: () {
            Navigator.pushNamed(context, '/create-organization');
          },
          color: AppColors.white,
          borderColor: AppColors.grey300,
          textColor: AppColors.primary,
          text: 'Buat Organisasi Baru',
        ),
      ],
    );
  }
}
