import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../blocs/notification_bloc.dart';
import '../blocs/notification_event.dart';
import '../blocs/notification_state.dart';
import '../widgets/dialog/notification_detail_dialog.dart';
import '../widgets/notification_card.dart';

class FleetNotificationPage extends StatelessWidget {
  const FleetNotificationPage({super.key});

  static const String routeName = '/fleet-notification';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<NotificationBloc>()..add(const NotificationFetchRequested()),
      child: Scaffold(
        appBar: const CustomSimpleAppBar(title: 'Notifikasi'),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading || state is NotificationInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<NotificationBloc>().add(
                        const NotificationFetchRequested(),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(child: Text('Belum ada notifikasi'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationBloc>().add(
                    const NotificationReloadRequested(),
                  );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = state.notifications[index];
                    return NotificationCard(
                      item: item,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => NotificationDetailDialog(
                            title: item.title,
                            message: item.message,
                            createdAt: item.createdAt,
                          ),
                        );

                        if(!item.isRead){
                          context.read<NotificationBloc>().add(
                            NotificationMarkAsRead(item.id),
                          );
                        }
                        
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
