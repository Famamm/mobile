import 'package:fleetops_mobile/features/inspection/presentation/widgets/cards/inspection_item_card.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/buttons/inspection_status_button.dart';
import 'package:flutter/material.dart';
import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';

class MesinSection extends StatelessWidget {
  final List<InspectionItemEntity> items;
  final Map<String, TextEditingController> noteControllers;
  final bool Function(String itemId) isExpanded;
  final void Function(String itemId) onToggleExpanded;
  final void Function(String itemId, InspectionStatus status) onStatusChanged;
  final void Function(String itemId, String note) onNoteChanged;
  final void Function(String itemId) onPhotoTap;

  const MesinSection({
    super.key,
    required this.items,
    required this.noteControllers,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onStatusChanged,
    required this.onNoteChanged,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        final controller = noteControllers[item.id]!;
        return InspectionItemCard(
          key: ValueKey(item.id),
          item: item,
          isExpanded: isExpanded(item.id),
          noteController: controller,
          onStatusChanged: (status) => onStatusChanged(item.id, status),
          onNoteChanged: (note) => onNoteChanged(item.id, note),
          onToggleExpanded: () => onToggleExpanded(item.id),
          onPhotoTap: () => onPhotoTap(item.id),
        );
      }).toList(),
    );
  }
}
