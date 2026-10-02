import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../../../injection_container.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    _checkToken();
  }

  Future<void> _checkToken() async {
    await Future.delayed(const Duration(seconds: 2));

    final tokenService = sl<TokenService>();

    if (tokenService.hasToken()) {
      final roleName = tokenService.getRoleName();

      if (roleName == 'Admin') {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else if (roleName == 'Driver') {
        Navigator.pushReplacementNamed(context, '/main');
      } else if (roleName == 'FleetManager') {
        Navigator.pushReplacementNamed(context, '/fleet-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              Image.asset(
                'assets/images/Logo FleetOps2.png',
                width: 150,
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
