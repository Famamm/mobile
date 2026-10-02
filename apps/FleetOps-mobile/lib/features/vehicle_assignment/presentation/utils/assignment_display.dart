import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

const assignmentCardShadow = [
  BoxShadow(color: Color(0x0F111827), blurRadius: 18, offset: Offset(0, 6)),
];

// Nilai status dari API tidak diubah, hanya label tampilannya.
String vehicleStatusLabel(String status) =>
    switch (status.trim().toLowerCase()) {
      'active' => 'Aktif',
      'maintenance' => 'Dalam Perawatan',
      'inactive' => 'Tidak Aktif',
      '' => '-',
      _ => status,
    };

Color vehicleStatusColor(String status) =>
    switch (status.trim().toLowerCase()) {
      'active' => AppColors.success,
      'maintenance' => AppColors.warning,
      _ => AppColors.grey400,
    };

IconData vehicleTypeIcon(String tipe) {
  final value = tipe.toLowerCase();
  if (value.contains('motor')) return Icons.two_wheeler_rounded;
  if (value.contains('bus')) return Icons.directions_bus_outlined;
  if (value.contains('mobil')) return Icons.directions_car_outlined;
  return Icons.local_shipping_outlined;
}

// 48250 -> "48.250"
String formatThousands(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String driverCode(int driverId) => 'DV-${driverId.toString().padLeft(4, '0')}';

String driverDisplayName(Driver driver) {
  final name = driver.name.trim();
  return name.isNotEmpty ? name : 'Pengemudi ${driverCode(driver.driverId)}';
}

// "Bambang Susanto" -> "BS", "Budi" -> "BU", "" -> "".
String driverInitials(String name) {
  final words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return '';
  if (words.length == 1) {
    return words.first.characters.take(2).toString().toUpperCase();
  }
  return '${words[0].characters.first}${words[1].characters.first}'
      .toUpperCase();
}

// API kadang sudah mengirim "SIM A", kadang hanya "B2 Umum".
String simLabel(String licenseType) {
  final value = licenseType.trim();
  if (value.isEmpty) return '';
  return value.toUpperCase().startsWith('SIM') ? value : 'SIM $value';
}

bool isDriverActive(Driver driver) {
  final status = driver.status.trim().toLowerCase();
  return status == 'active' || status == 'aktif';
}
