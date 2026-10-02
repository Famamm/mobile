import '../../domain/entities/inspection_history_detail_entity.dart';

class InspectionHistoryDetailModel extends InspectionHistoryDetailEntity {
  const InspectionHistoryDetailModel({
    required super.id,
    required super.vehicleName,
    required super.plateNumber,
    required super.status,
    required super.date,
    required super.completionScore,
    required super.categories,
    super.photoUrls,
  });

  factory InspectionHistoryDetailModel.fromJson(Map<String, dynamic> json) {
    // status: boolean true = SELESAI, false = ADA MASALAH
    final status = json['status'] == true ? 'SELESAI' : 'ADA MASALAH';

    // tanggal
    final rawDate = json['createdAt'] ?? json['inspectionDate'];
    final date = rawDate != null
        ? (DateTime.tryParse(rawDate.toString()) ?? DateTime.now()).toLocal()
        : DateTime.now();

    // vehicle — field langsung di root response
    final vehicleName =
        json['vehicleName'] as String? ?? 'Kendaraan #${json['vehicleId']}';
    final plateNumber = json['platNomor'] as String? ?? '-';

    // results → kelompokkan per kategori berdasarkan itemId range atau langsung flat
    final rawResults = json['results'] as List<dynamic>? ?? [];
    final total = rawResults.length;
    final ok = rawResults.where((r) => (r as Map)['condition'] == 0).length;
    final completionScore = total == 0 ? 100 : ((ok / total) * 100).round();

    // Mapping itemId → kategori berdasarkan data master inspeksi
    // itemId 1-5: Eksterior, 6-10: Interior, 11-15: Mesin, 16-20: Kelengkapan
    String _categoryFor(int itemId) {
      if (itemId <= 5) return 'Eksterior';
      if (itemId <= 10) return 'Interior';
      if (itemId <= 15) return 'Mesin';
      if (itemId <= 20) return 'Kelengkapan';
      return 'Lainnya';
    }

    String _iconFor(String categoryName) {
      return switch (categoryName) {
        'Eksterior' => 'eksterior',
        'Interior' => 'interior',
        'Mesin' => 'mesin',
        'Kelengkapan' => 'kelengkapan',
        _ => 'checklist',
      };
    }

    final categoryOrder = [
      'Eksterior',
      'Interior',
      'Mesin',
      'Kelengkapan',
      'Lainnya'
    ];
    final categoryMap = <String, List<InspectionCheckItemEntity>>{};

    for (final r in rawResults) {
      final m = r as Map<String, dynamic>;
      final itemId = m['itemId'] as int? ?? 0;
      final condition = m['condition'] as int? ?? 0;
      final note = m['note'] as String?;
      final item = InspectionCheckItemEntity(
        name: m['itemName'] as String? ?? 'Item',
        status: condition == 0 ? 'OK' : 'MASALAH',
        note: note?.isNotEmpty == true ? note : null,
      );
      final cat = _categoryFor(itemId);
      categoryMap.putIfAbsent(cat, () => []).add(item);
    }

    final categories = categoryOrder
        .where((name) => categoryMap.containsKey(name))
        .map((name) => InspectionCategoryEntity(
              name: name,
              iconAsset: _iconFor(name),
              items: categoryMap[name]!,
            ))
        .toList();

    // foto dari photos array
    final rawPhotos = json['photos'] as List<dynamic>? ?? [];
    final photoUrls = rawPhotos
        .map((p) {
          final m = p as Map<String, dynamic>;
          return m['imageUrlPath'] as String? ??
              m['url'] as String? ??
              m['photoUrl'] as String? ??
              '';
        })
        .where((url) => url.isNotEmpty)
        .toList();

    return InspectionHistoryDetailModel(
      id: (json['id'] ?? '').toString(),
      vehicleName: vehicleName,
      plateNumber: plateNumber,
      status: status,
      date: date,
      completionScore: completionScore,
      categories: categories,
      photoUrls: photoUrls,
    );
  }
}
