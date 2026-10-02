import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AssignmentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const AssignmentAppBar({super.key, this.title});

  static const double _toolbarHeight = 68;

  @override
  Size get preferredSize => const Size.fromHeight(_toolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: _toolbarHeight,
      leadingWidth: 72,
      leading: Center(
        child: _CircleBackButton(onPressed: () => Navigator.maybePop(context)),
      ),
      centerTitle: true,
      title: title == null
          ? null
          : Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.grey200),
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CircleBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Kembali',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.grey200),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14111827),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: const SizedBox.square(
              dimension: 44,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
