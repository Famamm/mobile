import 'package:fleetops_mobile/features/profile/presentation/pages/fleet_manager/fleet_profile_page.dart';
import 'package:fleetops_mobile/features/notification/presentation/pages/fleet_notification_page.dart';

import 'package:fleetops_mobile/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:fleetops_mobile/features/notification/presentation/blocs/notification_state.dart';

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class FleetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool backButton;
  final PreferredSizeWidget? bottom;
  final bool showLogo;
  final bool centerTitle;
  final bool showProfileIcon;
  final bool showNotificationIcon;
  final VoidCallback? onNotificationTap;

  const FleetAppBar({
    super.key,
    required this.title,
    this.backButton = false,
    this.actions,
    this.leading,
    this.bottom,
    this.showLogo = true,
    this.centerTitle = false,
    this.showProfileIcon = true,
    this.showNotificationIcon = false,
    this.onNotificationTap,
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
        if (showNotificationIcon)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap:
                  onNotificationTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FleetNotificationPage(),
                      ),
                    );
                  },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: AppColors.bgprimary,
                  shape: BoxShape.circle,
                ),
                child: BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    final int unread = state is NotificationLoaded
                        ? state.unreadCount
                        : 0;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_rounded,
                          color: AppColors.primary,
                        ),
                        if (unread > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 8,
                                minHeight: 8,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FleetProfilePage()),
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
