import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class NotificationFetchRequested extends NotificationEvent {
  const NotificationFetchRequested();
}

class NotificationReloadRequested extends NotificationEvent {
  const NotificationReloadRequested();
}

class NotificationMarkAsRead extends NotificationEvent {
  final int notificationId;
  const NotificationMarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}