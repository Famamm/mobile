import 'package:core/core.dart';

import '../models/notification_model.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final HttpService httpService;

  NotificationRemoteDataSourceImpl({required this.httpService});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await httpService.get(
        ApiConfig.fleetGetNotificationsEndpoint,
      );
      final data = response as Map<String, dynamic>;
      final list = (data['notifications'] as List<dynamic>? ?? []);
      return list
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      print('=== Notification ERROR: $e ===');
      throw Exception(msg);
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      await httpService.patch(
        ApiConfig.fleetReadNotificationEndpoint.replaceFirst('{notificationId}', notificationId.toString()),
        {}
      );
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      print('=== MarkAsRead ERROR: $e ===');
      throw Exception(msg);
    }
  }
}
