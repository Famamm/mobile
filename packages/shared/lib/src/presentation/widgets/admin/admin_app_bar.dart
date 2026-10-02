import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'package:gap/gap.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
  });

  Widget _buildTitle() {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/Logo FleetOps3.png', height: 32),
        Gap(8),
        Text(title),
      ],
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(),
      // centerTitle: centerTitle,
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      leading: leading,
      actions: [
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
                Navigator.pushNamed(context, '/admin-profile');
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
