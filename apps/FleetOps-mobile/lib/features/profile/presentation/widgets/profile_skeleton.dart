import 'package:flutter/material.dart';
import 'package:core/core.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Profile Header Skeleton
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.grey200,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 150,
                    height: 20,
                    color: AppColors.grey200,
                  ),
                ],
              ),
            ),
            // Stats Row Skeleton
            const SizedBox(height: 20),
            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            // Vehicle Section Skeleton
            const SizedBox(height: 24),
            Container(
              width: 150,
              height: 18,
              color: AppColors.grey200,
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              color: AppColors.grey200,
              margin: const EdgeInsets.only(bottom: 8),
            ),
            ...List.generate(
              3,
              (index) => Container(
                height: 80,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 45,
              color: AppColors.grey200,
              margin: const EdgeInsets.only(bottom: 16),
            ),
          ],
        ),
      ),
    );
  }
}
