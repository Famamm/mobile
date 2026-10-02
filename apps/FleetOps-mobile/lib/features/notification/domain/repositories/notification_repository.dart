import 'package:fleetops_mobile/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotification();
  
  Future<void> markAsRead(int notificationId);
}