
import '../repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase({required this.repository});

  Future<void> call(int notificationId) {
    return repository.markAsRead(notificationId);
  }
}