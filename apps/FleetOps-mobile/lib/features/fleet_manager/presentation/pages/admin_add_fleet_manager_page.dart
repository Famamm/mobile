import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../blocs/fleet_manager_bloc.dart';
import '../blocs/fleet_manager_event.dart';
import '../blocs/fleet_manager_state.dart';
import '../widgets/fleet_manager_add_form.dart';

class AdminAddFleetManagerPage extends StatelessWidget {
  const AdminAddFleetManagerPage({super.key});

  static const String routeName = '/admin/add-fleet-manager';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FleetManagerFormBloc>(),
      child: BlocListener<FleetManagerFormBloc, FleetManagerFormState>(
        listener: (context, state) {
          if (state is FleetManagerFormCreateSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return DriverCredentialsDialog(
                  username: state.fleetManager.username,
                  password: state.generatedPassword,
                  onOk: () {
                    Navigator.of(context).pop(true);
                  },
                );
              },
            );
          } else if (state is FleetManagerFormError) {
            SnackBarUtil.showError(context, state.message);
          }
        },
        child: Scaffold(
          appBar: CustomSimpleAppBar(title: 'Tambah Manajer Armada'),
          backgroundColor: AppColors.backgroundLight,
          body: BlocBuilder<FleetManagerFormBloc, FleetManagerFormState>(
            builder: (context, state) {
              final isLoading = state is FleetManagerFormSubmitting;

              return FleetManagerForm(
                submitLabel: 'Tambah Pengguna',
                isLoading: isLoading,
                onSubmit: (data) {
                  // Konfirmasi dulu sebelum submit (konsisten dengan driver)
                  showDialog(
                    context: context,
                    builder: (confirmContext) => ConfirmationDialog(
                      iconData: Icons.person_add_outlined,
                      iconColor: AppColors.primary,
                      iconBgColor: AppColors.bgprimary,
                      title: 'Tambah Manajer Armada',
                      message:
                          'Apakah Anda yakin ingin menambahkan manajer armada ini?',
                      confirmText: 'Ya, Tambah',
                      onConfirm: () {
                        context.read<FleetManagerFormBloc>().add(
                          SubmitCreateFleetManager(
                            fullName: data.fullName,
                            address: data.address,
                            phoneNumber: data.phoneNumber,
                            profilePhoto: data.profilePhoto,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
