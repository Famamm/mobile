import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String type;
  final String title;
  final String message;
  final int referenceId;
  final bool isRead;
  final String createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.referenceId,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationEntity copyWith({
    int? id,
    String? type,
    String? title,
    String? message,
    int? referenceId,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    message,
    referenceId,
    isRead,
    createdAt,
  ];
}
