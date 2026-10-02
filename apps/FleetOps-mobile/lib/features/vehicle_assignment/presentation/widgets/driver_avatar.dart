import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../utils/assignment_display.dart';

class DriverAvatar extends StatelessWidget {
  final String name;
  final double size;
  final bool showActiveDot;

  const DriverAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.showActiveDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final initials = driverInitials(name);
    final dotSize = size * 0.28;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            padding: EdgeInsets.all(size * 0.18),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: initials.isEmpty
                ? Icon(
                    Icons.person_rounded,
                    color: AppColors.white,
                    size: size * 0.5,
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: size * 0.34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
          ),
          if (showActiveDot)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
