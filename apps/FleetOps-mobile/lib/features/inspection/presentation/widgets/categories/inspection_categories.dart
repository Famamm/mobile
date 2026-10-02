enum InspectionCategory {
  eksterior,
  interior,
  mesin,
  kelengkapan,
}

extension InspectionCategoryExt on InspectionCategory {
  String get label {
    switch (this) {
      case InspectionCategory.eksterior:
        return 'Eksterior';
      case InspectionCategory.interior:
        return 'Interior';
      case InspectionCategory.mesin:
        return 'Mesin';
      case InspectionCategory.kelengkapan:
        return 'Kelengkapan';
    }
  }

  List<String> get items {
    switch (this) {
      case InspectionCategory.eksterior:
        return ['Ban', 'Lampu', 'Spion', 'Wiper', 'Body Kendaraan'];
      case InspectionCategory.interior:
        return [
          'Sabuk Pengaman',
          'Kaca Depan',
          'AC',
          'Indikator',
          'Klakson',
        ];
      case InspectionCategory.mesin:
        return [
          'Oli Mesin',
          'Air Radiator',
          'Aki',
          'Selang Radiator',
          'Kebocoran Oli',
        ];
      case InspectionCategory.kelengkapan:
        return [
          'KIR Kendaraan',
          'Segitiga Pengaman',
          'Kotak P3K',
          'Ban Cadangan',
          'APAR',
        ];
    }
  }
}
