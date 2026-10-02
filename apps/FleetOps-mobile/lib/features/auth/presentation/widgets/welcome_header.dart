import 'package:flutter/material.dart';
import 'package:core/core.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/Logo FleetOps1.png',
          height: 50,
          width: 150,
        ),
        SizedBox(height: 24),
        Text(
          'Kelola armada Anda dengan mudah.',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Platform terpercaya untuk bisnis transportasi modern. Efisien, cepat, dan andal.',
        ),
      ],
    );
  }
}
