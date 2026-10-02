import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notification_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
  }) : super(const NotificationInitial()) {
    on<NotificationFetchRequested>(_onFetch);
    on<NotificationReloadRequested>(_onReload);
    on<NotificationMarkAsRead>(_onMarkAsRead);
  }

  Future<void> _onFetch(
    NotificationFetchRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());
    try {
      final result = await getNotificationsUseCase();
      emit(NotificationLoaded(result));
    } catch (e) {
      emit(NotificationError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onReload(
    NotificationReloadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final result = await getNotificationsUseCase();
      emit(NotificationLoaded(result));
    } catch (e) {
      emit(NotificationError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onMarkAsRead(
    NotificationMarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final current = state;
    if (current is! NotificationLoaded) return;

    // ✅ Optimistic update: langsung ubah UI tanpa nunggu API
    final updated = current.notifications.map((n) {
      if (n.id == event.notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    emit(NotificationLoaded(updated));

    // ✅ Hit API di background
    try {
      await markNotificationAsReadUseCase(event.notificationId);
    } catch (e) {
      // Kalau gagal, rollback & emit error (opsional)
      emit(NotificationLoaded(current.notifications));
      emit(NotificationError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
