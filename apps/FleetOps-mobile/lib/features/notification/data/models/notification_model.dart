import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  final int id;
  final String type;
  final String title;
  final String message;
  final int referenceId;
  final bool isRead;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.referenceId,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      referenceId: json['referenceId'] ?? 0,
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'message': message,
        'referenceId': referenceId,
        'isRead': isRead,
        'createdAt': createdAt,
      };

  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        type: type,
        title: title,
        message: message,
        referenceId: referenceId,
        isRead: isRead,
        createdAt: createdAt,
      );
}