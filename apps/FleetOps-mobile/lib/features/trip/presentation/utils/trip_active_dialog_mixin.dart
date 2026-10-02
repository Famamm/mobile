import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_state.dart';
import '../../../../injection_container.dart';

import '../blocs/cancel_trip_bloc.dart';
import '../blocs/cancel_trip_event.dart';
import '../widgets/components/dialog_exit_confirmation.dart';
import '../widgets/components/dialog_end_confirmation.dart';


mixin TripActiveDialogMixin {
  // Callback untuk handle end confirmation
  void onEndTripConfirmed(BuildContext context);

  // Show dialog untuk keluar/cancel trip
  void showExitConfirmation(BuildContext context, String tripId) {
    final cancelTripBloc = context.read<CancelTripBloc>();
    final tokenService = sl<TokenService>();
    final parsedTripId = int.tryParse(tripId) ?? 0;
    final driverId = tokenService.getDriverId() ??
        ((context.read<AuthBloc>().state is AuthSuccess)
            ? (context.read<AuthBloc>().state as AuthSuccess).driverId ?? 1
            : 1);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => DialogExitConfirmation(
        tripId: parsedTripId,
        driverId: driverId,
        onCancelTrip: () {
          cancelTripBloc.add(
            CancelTripSubmitted(tripId: parsedTripId, driverId: driverId),
          );
        },
      ),
    );
  }

  // Show dialog konfirmasi sebelum end trip
  Future<void> showEndTripConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const DialogEndConfirmation(),
    );

    if (confirmed == true) {
      onEndTripConfirmed(context);
    }
  }
}
