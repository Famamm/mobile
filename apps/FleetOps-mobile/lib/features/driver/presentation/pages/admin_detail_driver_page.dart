import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../blocs/driver_detail_bloc.dart';
import '../blocs/driver_detail_event.dart';
import '../blocs/driver_detail_state.dart';
import '../widgets/driver_action_button.dart';
import '../widgets/driver_detail_card.dart';
import '../widgets/driver_info_card.dart';
import '../widgets/license_info_card.dart';

import '../../domain/entities/driver.dart';
import '../../domain/repositories/driver_repository.dart';

import '../../../../injection_container.dart';

class AdminDriverDetailPage extends StatelessWidget {
  final int driverId;
  const AdminDriverDetailPage({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverDetailBloc(repository: sl<DriverRepository>())
        ..add(LoadDriverDetail(driverId)),
      child: const _AdminDriverDetailView(),
    );
  }
}

class _AdminDriverDetailView extends StatelessWidget {
  const _AdminDriverDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverDetailBloc, DriverDetailState>(
      listener: (context, state) {
        if (state is DriverDetailDeleteSuccess) {
          Navigator.of(context).pop();
        }

        if (state is DriverDetailError) {
          SnackBarUtil.showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: CustomSimpleAppBar(title: 'Detail Pengemudi'),
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<DriverDetailBloc, DriverDetailState>(
          builder: (context, state) {
            if (state is DriverDetailLoading || state is DriverDetailInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is DriverDetailError) {
              return Center(child: Text(state.message));
            }

            if (state is! DriverDetailLoaded) {
              return const SizedBox.shrink();
            }

            final Driver currentDriver = state.driver;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DriverDetailCard(driver: currentDriver),
                  const SizedBox(height: 12),
                  DriverInfoCards(
                    totalTrips: currentDriver.totalTrips,
                    address: currentDriver.address,
                  ),
                  const SizedBox(height: 12),
                  LicenseInfoCard(
                    licenseType: currentDriver.licenseType,
                    licenseExpiry: currentDriver.licenseExpiry,
                    licenseImageUrl: currentDriver.licenseImageUrl,
                  ),
                  const SizedBox(height: 24),
                  DriverActionButtons(driver: currentDriver),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
