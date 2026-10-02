import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

import '../../../../../injection_container.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../blocs/start_trip_bloc.dart';
import '../../widgets/forms/start_trip_form.dart';

class TripStartFormCard extends StatefulWidget {
  const TripStartFormCard({super.key});

  @override
  State<TripStartFormCard> createState() => TripStartFormCardState();
}

class TripStartFormCardState extends State<TripStartFormCard> {
  int _odometer = 0;

  @override
  void initState() {
    super.initState();
    _odometer = sl<TokenService>().getActiveVehicleOdometer();
  }

  void refresh() {
    final latest = sl<TokenService>().getActiveVehicleOdometer();
    if (latest != _odometer) {
      setState(() => _odometer = latest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider<StartTripBloc>(
          create: (context) => StartTripBloc(
            repository: sl<TripRepository>(),
          ),
          child: StartTripForm(key: ValueKey('form_$_odometer')),
        ),
      ),
    );
  }
}
