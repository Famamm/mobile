import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:shared/shared.dart';

import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../blocs/delete_vehicle_bloc.dart';
import '../blocs/delete_vehicle_event.dart';
import '../blocs/delete_vehicle_state.dart';
import '../widgets/delete_vehicle_dialog.dart';
import '../widgets/vehicle_info_grid.dart';
import '../widgets/vehicle_photo.dart';
import 'admin_edit_vehicle_page.dart';

class AdminVehicleDetailPage extends StatefulWidget {
  final Vehicle vehicle;

  const AdminVehicleDetailPage({super.key, required this.vehicle});

  @override
  State<AdminVehicleDetailPage> createState() => _AdminVehicleDetailPageState();
}

class _AdminVehicleDetailPageState extends State<AdminVehicleDetailPage> {
  late Vehicle _vehicle;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _vehicle = widget.vehicle;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final full = await sl<VehicleRepository>().getVehicleById(
        widget.vehicle.vehicleId,
      );
      if (mounted) {
        setState(() {
          _vehicle = full;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VehicleDeleteBloc>(),
      child: BlocListener<VehicleDeleteBloc, VehicleDeleteState>(
        listener: (context, state) {
          if (state is VehicleDeleteSuccess) {
            SnackBarUtil.showSuccess(context, 'Kendaraan berhasil dihapus');
            Navigator.pop(context, true);
          } else if (state is VehicleDeleteFailure) {
            SnackBarUtil.showError(context, state.error);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: CustomSimpleAppBar(title: 'Detail Kendaraan'),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VehiclePhoto(vehicle: _vehicle),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // VehicleFuelEfficiencyCard(vehicle: _vehicle),
                            // const SizedBox(height: 16),
                            VehicleInfoGrid(vehicle: _vehicle),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Edit Kendaraan',
                              icon: Icons.edit_outlined,
                              // color: Colors.transparent,
                              // textColor: AppColors.primary,
                              // borderColor: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AdminEditVehiclePage(vehicle: _vehicle),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Builder(
                              builder: (innerContext) => CustomButton(
                                text: 'Hapus Kendaraan',
                                icon: Icons.delete_outline,
                                color: Colors.transparent,
                                textColor: AppColors.error,
                                borderColor: AppColors.error,
                                borderRadius: BorderRadius.circular(12),
                                onPressed: () => showDeleteVehicleDialog(
                                  innerContext,
                                  vehicleName: _vehicle.vehicleName,
                                  onConfirm: () {
                                    if (mounted) {
                                      innerContext
                                          .read<VehicleDeleteBloc>()
                                          .add(
                                            DeleteVehicleRequested(
                                              vehicleId: _vehicle.vehicleId,
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
