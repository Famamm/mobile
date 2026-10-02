import 'package:flutter/material.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/categories/inspection_categories.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/categories/eksterior/eksterior_section.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/categories/interior/interior_section.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/categories/kelengkapan/kelengkapan_section.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/categories/mesin/mesin_section.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/cards/inspection_checklist_header.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/buttons/inspection_status_button.dart';
import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';

class InspectionChecklistContainer extends StatelessWidget {
  final InspectionCategory selectedCategory;
  final List<InspectionItemEntity> items;
  final Map<String, TextEditingController> noteControllers;
  final bool Function(String itemId) isExpanded;
  final void Function(String itemId) onToggleExpanded;
  final void Function(String itemId, InspectionStatus status) onStatusChanged;
  final void Function(String itemId, String note) onNoteChanged;
  final void Function(String itemId) onPhotoTap;
  final Map<InspectionCategory, int> completedPerCategory;

  const InspectionChecklistContainer({
    super.key,
    required this.selectedCategory,
    required this.items,
    required this.noteControllers,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onStatusChanged,
    required this.onNoteChanged,
    required this.onPhotoTap,
    required this.completedPerCategory,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = items.length;
    final completedItems = completedPerCategory[selectedCategory] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InspectionChecklistHeader(
          categoryName: selectedCategory.label,
          totalItems: totalItems,
          completedItems: completedItems,
        ),
        const SizedBox(height: 14),
        _buildSection(),
      ],
    );
  }

  Widget _buildSection() {
    switch (selectedCategory) {
      case InspectionCategory.eksterior:
        return EksteriorSection(
          items: items,
          noteControllers: noteControllers,
          isExpanded: isExpanded,
          onToggleExpanded: onToggleExpanded,
          onStatusChanged: onStatusChanged,
          onNoteChanged: onNoteChanged,
          onPhotoTap: onPhotoTap,
        );
      case InspectionCategory.interior:
        return InteriorSection(
          items: items,
          noteControllers: noteControllers,
          isExpanded: isExpanded,
          onToggleExpanded: onToggleExpanded,
          onStatusChanged: onStatusChanged,
          onNoteChanged: onNoteChanged,
          onPhotoTap: onPhotoTap,
        );
      case InspectionCategory.mesin:
        return MesinSection(
          items: items,
          noteControllers: noteControllers,
          isExpanded: isExpanded,
          onToggleExpanded: onToggleExpanded,
          onStatusChanged: onStatusChanged,
          onNoteChanged: onNoteChanged,
          onPhotoTap: onPhotoTap,
        );
      case InspectionCategory.kelengkapan:
        return KelengkapanSection(
          items: items,
          noteControllers: noteControllers,
          isExpanded: isExpanded,
          onToggleExpanded: onToggleExpanded,
          onStatusChanged: onStatusChanged,
          onNoteChanged: onNoteChanged,
          onPhotoTap: onPhotoTap,
        );
    }
  }
}
