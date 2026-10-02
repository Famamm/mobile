import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/categories/inspection_categories.dart';

class InspectionValidator {
  static bool isItemCompleted(InspectionItemEntity item) {
    if (item.status == 'none') return false;
    if (item.status == 'ok') return true;

    if (item.status == 'not_ok') {
      final hasNote = item.note != null && item.note!.trim().isNotEmpty;
      final hasPhoto =
          item.photoPath != null && item.photoPath!.trim().isNotEmpty;
      return hasNote && hasPhoto;
    }

    return false;
  }

  static int countCompleted(List<InspectionItemEntity> items) {
    return items.where((item) => isItemCompleted(item)).length;
  }

  static List<InspectionItemEntity> getInvalidItems(
    List<InspectionItemEntity> items,
  ) {
    return items.where((item) {
      if (item.status != 'not_ok') return false;
      final hasNote = item.note != null && item.note!.trim().isNotEmpty;
      final hasPhoto =
          item.photoPath != null && item.photoPath!.trim().isNotEmpty;
      return !hasNote || !hasPhoto;
    }).toList();
  }

  static bool itemMatchesCategory(
    InspectionItemEntity item,
    InspectionCategory category,
  ) {
    return item.category.toLowerCase() == category.label.toLowerCase() ||
        item.category.toLowerCase() == category.name.toLowerCase();
  }
}
