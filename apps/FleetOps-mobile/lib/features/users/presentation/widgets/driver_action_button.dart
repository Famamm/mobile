import 'package:core/core.dart';
import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';
import 'package:fleetops_mobile/features/driver/presentation/blocs/driver_list_bloc.dart';
import 'package:fleetops_mobile/features/driver/presentation/blocs/driver_list_event.dart';
import 'package:fleetops_mobile/features/driver/presentation/pages/admin_edit_driver_page.dart';
import 'package:shared/src/presentation/dialog/detele_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverActionButtons extends StatelessWidget {
  final Driver driver;

  const DriverActionButtons({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            label: const Text(
              'Ubah Data Pengemudi',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final shouldPopToRoot = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminEditDriverPage(driver: driver),
                ),
              );
              if (shouldPopToRoot == true && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'Hapus Pengemudi',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final confirm = await DeleteConfirmationDialog.show(
                context,
                title: 'Hapus Pengemudi',
                message: 'Apakah Anda yakin ingin menghapus pengemudi ini?',
                confirmText: 'Ya, Hapus',
                cancelText: 'Batal',
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                confirmButtonColor: AppColors.primary,
              );

              debugPrint('[DELETE DRIVER] confirm: $confirm');

              if (!context.mounted || confirm != true) {
                return;
              }

              debugPrint(
                '[DELETE DRIVER] driverId: ${driver.driverId}',
              );

              context.read<DriverListBloc>().add(
                    DeleteDriver(
                      driverId: driver.driverId,
                    ),
                  );
            },
          ),
        ),
      ],
    );
  }
}
