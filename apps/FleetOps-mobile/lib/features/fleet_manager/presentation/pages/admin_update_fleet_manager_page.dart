import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../blocs/fleet_manager_bloc.dart';
import '../blocs/fleet_manager_detail_bloc.dart';
import '../blocs/fleet_manager_detail_event.dart';
import '../blocs/fleet_manager_detail_state.dart';
import '../blocs/fleet_manager_event.dart';
import '../blocs/fleet_manager_state.dart';
import '../widgets/fleet_manager_edit_form.dart';

class AdminUpdateFleetManager extends StatelessWidget {
  final int userId;
  const AdminUpdateFleetManager({super.key, required this.userId});

  static const String routeName = '/admin/update-fleet-manager';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FleetManagerDetailBloc>()
          ..add(LoadFleetManagerDetail(userId))),
        BlocProvider(create: (_) => sl<FleetManagerFormBloc>()),
      ],
      child: BlocListener<FleetManagerFormBloc, FleetManagerFormState>(
        listener: (context, state) {
          if (state is FleetManagerFormUpdateSuccess) {
            SnackBarUtil.showSuccess(context, 'Data fleet manager berhasil diperbarui');
            Navigator.of(context).pop(true);
          } else if (state is FleetManagerFormError) {
            SnackBarUtil.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: const CustomSimpleAppBar(title: 'Ubah Manajer Armada'),
          body: BlocBuilder<FleetManagerDetailBloc, FleetManagerDetailState>(
            builder: (context, state) {
              if (state is FleetManagerDetailLoading || state is FleetManagerDetailInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is FleetManagerDetailError) {
                return Center(child: Text(state.message));
              }
              if (state is FleetManagerDetailLoaded) {
                final m = state.fleetManager;
                return BlocBuilder<FleetManagerFormBloc, FleetManagerFormState>(
                  builder: (context, formState) {
                    return FleetManagerEditForm(
                      submitLabel: 'Perbarui',
                      isLoading: formState is FleetManagerFormSubmitting,
                      initialFullName: m.fullName,
                      initialAddress: m.address,
                      initialPhoneNumber: m.phoneNumber,
                      initialPhotoUrl: m.profilePhoto.isEmpty ? null : m.profilePhoto,
                      onSubmit: (data) {
                        context.read<FleetManagerFormBloc>().add(
                          SubmitUpdateFleetManager(
                            userId: userId,
                            fullName: data.fullName,
                            address: data.address,
                            phoneNumber: data.phoneNumber,
                            profilePhoto: data.profilePhoto,
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}