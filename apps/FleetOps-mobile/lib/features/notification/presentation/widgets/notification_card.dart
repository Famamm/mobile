import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../domain/entities/notification_entity.dart';
import '../utils/notification_date_formater.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity item;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !item.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isUnread ? AppColors.bgprimary : AppColors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: isUnread
              ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
              : Border.all(color: AppColors.grey200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUnread)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, right: 8.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isUnread ? AppColors.primary : AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isUnread ? AppColors.grey600 : AppColors.grey500,
                        fontWeight:
                            isUnread ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatNotificationTime(item.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}