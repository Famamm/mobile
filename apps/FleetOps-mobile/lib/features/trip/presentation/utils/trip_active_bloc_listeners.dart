import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

import '../../../../injection_container.dart';

import '../blocs/end_trip_bloc.dart';
import '../blocs/end_trip_state.dart';
import '../blocs/cancel_trip_bloc.dart';
import '../blocs/cancel_trip_state.dart';

class TripActiveBlocListeners extends StatelessWidget {
  final Widget child;
  final int Function() getOdometerAkhir;
  final Function(bool) onSubmissionStateChange; // callback untuk isSubmitting

  const TripActiveBlocListeners({
    required this.child,
    required this.getOdometerAkhir,
    required this.onSubmissionStateChange,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EndTripBloc, EndTripState>(
          listener: (context, state) => _handleEndTripState(context, state),
        ),
        BlocListener<CancelTripBloc, CancelTripState>(
          listener: (context, state) => _handleCancelTripState(context, state),
        ),
      ],
      child: child,
    );
  }

  void _handleEndTripState(BuildContext context, EndTripState state) {
    if (state is EndTripLoading) {
      _showLoadingDialog(context, 'Mengakhiri perjalanan...');
    } else if (state is EndTripSuccess) {
      _handleEndTripSuccess(context);
    } else if (state is EndTripError) {
      _handleEndTripError(context, state.message);
    }
  }

  void _handleCancelTripState(BuildContext context, CancelTripState state) {
    if (state is CancelTripSuccess) {
      SnackBarUtil.showSuccess(
        context,
        'Perjalanan berhasil dibatalkan',
      );
      Navigator.pop(context, false);
    } else if (state is CancelTripError) {
      SnackBarUtil.showError(context, state.message);
    }
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _handleEndTripSuccess(BuildContext context) {
    Navigator.pop(context); // tutup loading dialog

    final odo = getOdometerAkhir();

    // Simpan odometer terbaru
    final ts = sl<TokenService>();
    ts.saveLastOdometer(odo);

    // Sync dengan vehicle aktif
    final vehicleId = ts.getActiveVehicleId();
    final vehicleName = ts.getActiveVehicleName() ?? '';
    final vehiclePlat = ts.getActiveVehiclePlat() ?? '';

    if (vehicleId != null) {
      ts.saveActiveVehicle(
        vehicleId: vehicleId,
        vehicleName: vehicleName,
        platNomor: vehiclePlat,
        odometer: odo,
      );
    }

    SnackBarUtil.showSuccess(context, 'Perjalanan berhasil diakhiri');
    Navigator.pop(context, true);
  }

  void _handleEndTripError(BuildContext context, String message) {
    onSubmissionStateChange(false); // set isSubmitting = false
    Navigator.pop(context); // tutup loading dialog
    SnackBarUtil.showError(context, message);
  }
}
