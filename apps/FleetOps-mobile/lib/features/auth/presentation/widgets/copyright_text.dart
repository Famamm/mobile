import 'package:flutter/material.dart';
import 'package:core/core.dart';

class CopyrightText extends StatelessWidget {
  const CopyrightText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(
        '© 2026 FleetOps. All Rights Reserved.',
        style: TextStyle(color: AppColors.grey500, fontSize: 12),
      ),
    );
  }
}
