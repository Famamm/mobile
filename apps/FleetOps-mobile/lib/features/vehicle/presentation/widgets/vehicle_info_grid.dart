import 'package:flutter/material.dart';

import '../../domain/entities/vehicle.dart';
import 'info_tile.dart';

class VehicleInfoGrid extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleInfoGrid({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Kendaraan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            InfoTile(label: 'NAMA KENDARAAN', value: vehicle.vehicleName),
            InfoTile(label: 'TIPE', value: vehicle.tipe),
            InfoTile(label: 'MUATAN MAKSIMAL', value: vehicle.muatanMax == 0
                ? '-'
                : '${vehicle.muatanMax} kg'),
            InfoTile(label: 'TIPE BENSIN', value: vehicle.tipeBensin),
            InfoTile(label: 'PLAT NOMOR', value: vehicle.platNomor),
            InfoTile(
              label: 'TAHUN',
              value: vehicle.tahunPembuatan == 0
                  ? '-'
                  : vehicle.tahunPembuatan.toString(),
            ),
          ],
        ),
      ],
    );
  }
}
