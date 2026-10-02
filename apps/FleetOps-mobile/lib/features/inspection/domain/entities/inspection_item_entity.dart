class InspectionItemEntity {
  final String id; // local key: "eksterior:Ban"
  final int? dbId; // ID integer dari database backend
  final String name;
  final String category;
  final String status; // 'none' | 'ok' | 'not_ok'
  final String? note;
  final String? photoPath;

  const InspectionItemEntity({
    required this.id,
    this.dbId,
    required this.name,
    required this.category,
    this.status = 'none',
    this.note,
    this.photoPath,
  });

  static const _unset = Object();

  InspectionItemEntity copyWith({
    String? id,
    int? dbId,
    String? name,
    String? category,
    String? status,
    Object? note = _unset,
    Object? photoPath = _unset,
  }) {
    return InspectionItemEntity(
      id: id ?? this.id,
      dbId: dbId ?? this.dbId,
      name: name ?? this.name,
      category: category ?? this.category,
      status: status ?? this.status,
      note: identical(note, _unset) ? this.note : note as String?,
      photoPath:
          identical(photoPath, _unset) ? this.photoPath : photoPath as String?,
    );
  }
}
