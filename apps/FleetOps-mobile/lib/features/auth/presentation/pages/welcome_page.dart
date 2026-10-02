import "package:flutter/material.dart";
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import "../widgets/copyright_text.dart";
import "../widgets/welcome_button.dart";
import "../widgets/welcome_header.dart";

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomCard(
              padding: const EdgeInsets.all(0.0),
              backgroundColor: AppColors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WelcomeHeader(),
                        SizedBox(height: 20),
                        WelcomeButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CopyrightText(),
        ],
      ),
    );
  }
}
