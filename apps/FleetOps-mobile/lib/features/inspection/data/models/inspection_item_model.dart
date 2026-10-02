import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';

class InspectionItemModel extends InspectionItemEntity {
  const InspectionItemModel({
    required super.id,
    super.dbId,
    required super.name,
    required super.category,
    super.status,
    super.note,
    super.photoPath,
  });

  factory InspectionItemModel.fromJson(Map<String, dynamic> json) {
    final dbId = json['id'] as int?;
    final name = json['name'] as String? ?? '';
    final categoryName =
        json['categoryName'] as String? ?? json['category'] as String? ?? '';
    return InspectionItemModel(
      id: 'db:$dbId',
      dbId: dbId,
      name: name,
      category: categoryName,
      status: 'none',
    );
  }

  factory InspectionItemModel.fromEntity(InspectionItemEntity entity) {
    return InspectionItemModel(
      id: entity.id,
      dbId: entity.dbId,
      name: entity.name,
      category: entity.category,
      status: entity.status,
      note: entity.note,
      photoPath: entity.photoPath,
    );
  }
}
