import 'package:flutter/material.dart';
import 'package:core/core.dart';

class FuelHistorySkeleton extends StatelessWidget {
  const FuelHistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          _Box(width: 160, height: 24, radius: 6),
          const SizedBox(height: 14),
          // Search bar skeleton
          _Box(width: double.infinity, height: 48, radius: 10),
          const SizedBox(height: 16),
          // Item cards skeleton
          ...List.generate(4, (_) => _ItemCardSkeleton()),
        ],
      ),
    );
  }
}

class _ItemCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              _Box(width: 140, height: 14, radius: 4),
              _Box(width: 72, height: 22, radius: 6),
            ],
          ),
          const SizedBox(height: 10),
          _Box(width: 180, height: 16, radius: 4),
          const SizedBox(height: 6),
          _Box(width: 100, height: 13, radius: 4),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Box(width: 70, height: 11, radius: 3),
                  const SizedBox(height: 4),
                  _Box(width: 110, height: 14, radius: 4),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Box(width: 60, height: 11, radius: 3),
                  const SizedBox(height: 4),
                  _Box(width: 90, height: 14, radius: 4),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _Box({this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
