import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

import '../../../../main.dart';
import '../../../profile/presentation/blocs/profile_event.dart';
import '../../../profile/presentation/blocs/profile_bloc.dart';
import '../widgets/cards/trip_start_form_card.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  static String routeName = '/trip-start';

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> with RouteAware {
  bool _subscribed = false;
  final _formCardKey = GlobalKey<TripStartFormCardState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      final route = ModalRoute.of(context);
      if (route != null && !_subscribed) {
        routeObserver.subscribe(this, route);
        _subscribed = true;
      }
      context.read<ProfileBloc>().add(LoadProfileEvent());
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Dipanggil saat kembali dari TripActivePage (setelah end/cancel trip)
    _formCardKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'FleetOps'),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                VehicleStatusCard(),
                TripSafetyReminderCard(),
                TripStartFormCard(key: _formCardKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
