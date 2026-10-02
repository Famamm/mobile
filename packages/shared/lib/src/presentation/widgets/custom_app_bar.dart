import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_state.dart';
import 'package:fleetops_mobile/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fleetops_mobile/features/profile/presentation/blocs/profile_event.dart';
import 'package:fleetops_mobile/features/profile/presentation/pages/driver/driver_profile_page.dart';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool backButton;
  final PreferredSizeWidget? bottom;
  final bool showLogo;
  final bool centerTitle;
  final bool showProfileIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backButton = false,
    this.actions,
    this.leading,
    this.bottom,
    this.showLogo = true,
    this.centerTitle = false,
    this.showProfileIcon = true,
  });

  Widget _buildTitle() {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo) ...[
          Image.asset('assets/images/Logo FleetOps3.png', height: 32),
          Gap(8),
        ],
        Text(title),
      ],
    );

    if (centerTitle) {
      return Center(child: content);
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(),
      centerTitle: centerTitle,
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: backButton,
      scrolledUnderElevation: 0,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      leading: leading,
      actions: [
        if (showProfileIcon)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.bgprimary,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                child: Icon(Icons.person_2_rounded, color: AppColors.primary),
                onTap: () {
                  final driverId = sl<TokenService>().getDriverId() ??
                      (context.read<AuthBloc>().state is AuthSuccess
                          ? ((context.read<AuthBloc>().state as AuthSuccess)
                                  .driverId ??
                              0)
                          : 0);
                  if (driverId == 0) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (_) =>
                            sl<ProfileBloc>()..add(LoadProfileEvent()),
                        child: const DriverProfilePage(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
