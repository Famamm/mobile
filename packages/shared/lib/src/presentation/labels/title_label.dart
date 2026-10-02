import 'package:flutter/material.dart';
import 'package:core/core.dart';

Widget titleLabel(String label, {required bool required}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            if (required)
              const Text(' *',
                  style: TextStyle(color: AppColors.error, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
