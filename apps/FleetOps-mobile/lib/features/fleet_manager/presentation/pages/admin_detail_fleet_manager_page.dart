import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/fleet_manager_entity.dart';
import '../../domain/repositories/fleet_manager_repository.dart';
import '../blocs/fleet_manager_detail_bloc.dart';
import '../blocs/fleet_manager_detail_event.dart';
import '../blocs/fleet_manager_detail_state.dart';
import 'admin_update_fleet_manager_page.dart';

class AdminDetailFleetManagerPage extends StatelessWidget {
  final int fleetId;
  const AdminDetailFleetManagerPage({super.key, required this.fleetId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FleetManagerDetailBloc(repository: sl<FleetManagerRepository>())
            ..add(LoadFleetManagerDetail(fleetId)),
      child: const _AdminFleetManagerDetailView(),
    );
  }
}

class _AdminFleetManagerDetailView extends StatelessWidget {
  const _AdminFleetManagerDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FleetManagerDetailBloc, FleetManagerDetailState>(
      listener: (context, state) {
        if (state is FleetManagerDetailDeleteSuccess) {
          Navigator.of(context).pop();
        }

        if (state is FleetManagerDetailError) {
          SnackBarUtil.showError(context, state.message);
        }

        if (state is FleetManagerResetPasswordSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => DriverCredentialsDialog(
              username: state.username,
              password: state.password,
              onOk: () {
                Navigator.of(dialogContext).pop();
                final bloc = context.read<FleetManagerDetailBloc>();
                final currentState = bloc.state;
                if (currentState is FleetManagerDetailLoaded) {
                  bloc.add(
                    LoadFleetManagerDetail(currentState.fleetManager.userId),
                  );
                }
              },
            ),
          );
        }

        if (state is FleetManagerResetPasswordError) {
          SnackBarUtil.showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: CustomSimpleAppBar(title: 'Detail Manajer Armada'),
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<FleetManagerDetailBloc, FleetManagerDetailState>(
          builder: (context, state) {
            if (state is FleetManagerDetailLoading ||
                state is FleetManagerDetailInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is FleetManagerDetailError) {
              return Center(child: Text(state.message));
            }

            if (state is! FleetManagerDetailLoaded) {
              return const SizedBox.shrink();
            }

            final FleetManagerEntity currentFleet = state.fleetManager;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.grey200,
                          backgroundImage: currentFleet.profilePhoto.isNotEmpty
                              ? NetworkImage(currentFleet.profilePhoto)
                              : null,
                          child: currentFleet.profilePhoto.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.grey500,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentFleet.fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: US${currentFleet.userId.toString().padLeft(4, '0')}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.success),
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                currentFleet.status!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  CustomCardForm(
                    title: 'Informasi Manajer Armada',
                    formFields: [
                      titleLabel('Nama Lengkap', required: false),
                      ReadOnlyField(
                        borderRadius: 8,
                        hintText: currentFleet.fullName,
                      ),
                      const SizedBox(height: 12),
                      titleLabel('Alamat', required: false),
                      ReadOnlyField(
                        borderRadius: 8,
                        hintText: currentFleet.address,
                      ),
                      const SizedBox(height: 12),
                      titleLabel('Nomor Telepon', required: false),
                      ReadOnlyField(
                        borderRadius: 8,
                        hintText: currentFleet.phoneNumber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Update Manajer',
                    onPressed: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminUpdateFleetManager(
                            userId: currentFleet.userId,
                          ),
                        ),
                      );

                      // Kalau halaman edit di-pop dengan `true`, berarti update sukses
                      if (updated == true && context.mounted) {
                        context.read<FleetManagerDetailBloc>().add(
                          LoadFleetManagerDetail(currentFleet.userId),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Reset Password',
                    color: AppColors.backgroundLight,
                    borderColor: AppColors.primary,
                    textColor: AppColors.primary,
                    icon: Icons.lock_reset,
                    onPressed: () {
                      context.read<FleetManagerDetailBloc>().add(
                        ResetFleetManagerPassword(currentFleet.userId),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Hapus Manajer',
                    color: AppColors.backgroundLight,
                    borderColor: AppColors.error,
                    textColor: AppColors.error,
                    icon: Icons.delete_outline,
                    onPressed: () async {
                      final confirm = await DeleteConfirmationDialog.show(
                        context,
                        title: 'Hapus Manajer',
                        message:
                            'Apakah Anda yakin ingin menghapus manajer ini?',
                        confirmText: 'Ya, Hapus',
                        cancelText: 'Batal',
                        icon: Icons.person_outline,
                        iconColor: AppColors.primary,
                        confirmButtonColor: AppColors.primary,
                      );

                      if (!context.mounted || confirm != true) {
                        return;
                      }

                      context.read<FleetManagerDetailBloc>().add(
                        DeleteFleetManager(currentFleet.userId),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
