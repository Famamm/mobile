class InspectionStrings {
  // ── No Vehicle Selected ────────────────────────────────────────────────────
  static const String noVehicleSelectedTitle = 'Kendaraan Belum Dipilih';
  static const String selectVehicleFirstDesc =
      'Pilih kendaraan aktif di halaman Profile sebelum melakukan inspeksi harian.';
  static const String goToProfile = 'Ke Halaman Profile';

  // ── Validation Messages ────────────────────────────────────────────────────
  static const String notePhotoRequiredForNotOk =
      '⚠️ Catatan dan foto wajib diisi untuk status Tidak OK';

  // ── Success & Completion ───────────────────────────────────────────────────
  static const String inspectionComplete = 'Inspeksi Selesai';
  static const String continueToTrip = 'Lanjut ke Perjalanan';

  // ── Helper untuk dynamic messages ───────────────────────────────────────────
  static String incompleteNotOkItems(int count) {
    return '⚠️ $count item "Tidak OK" belum dilengkapi catatan dan foto';
  }
}

class InspectionDimens {
  static const double iconContainerSize = 72;
  static const double smallIconSize = 36;
  static const double buttonHeight = 46;
  static const double borderRadius = 12;
  static const double dialogBorderRadius = 20;
  static const double smallPaddingSize = 16;
}

class InspectionColors {
  static const int noVehicleIconBgColor = 0xFFFFF8E1;
  static const int noVehicleIconColor = 0xFFFFB300;
}
