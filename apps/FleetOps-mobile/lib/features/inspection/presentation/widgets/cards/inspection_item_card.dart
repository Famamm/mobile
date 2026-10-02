import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/buttons/inspection_status_button.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/forms/inspection_photo_box.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/forms/inspection_problem_note_field.dart';

class InspectionItemCard extends StatelessWidget {
  final InspectionItemEntity item;
  final bool isExpanded;
  final TextEditingController noteController;
  final ValueChanged<InspectionStatus> onStatusChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onToggleExpanded;
  final VoidCallback onPhotoTap;

  const InspectionItemCard({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.noteController,
    required this.onStatusChanged,
    required this.onNoteChanged,
    required this.onToggleExpanded,
    required this.onPhotoTap,
  });

  bool get _hasDetails {
    final note = item.note?.trim() ?? '';
    final photo = item.photoPath?.trim() ?? '';
    return note.isNotEmpty || photo.isNotEmpty;
  }

  bool get _showDetails => isExpanded || _hasDetails;

  InspectionStatus _statusFromString(String status) {
    switch (status) {
      case 'ok':
        return InspectionStatus.ok;
      case 'not_ok':
        return InspectionStatus.notOk;
      default:
        return InspectionStatus.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusFromString(item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
        boxShadow: const [
          BoxShadow(
            color: AppColors.grey200,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (status != InspectionStatus.none) _buildStatusBadge(status),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onToggleExpanded,
                child: Icon(
                  _showDetails
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),

          // ── Status Buttons ────────────────────────────────────────────
          const SizedBox(height: 10),
          InspectionStatusButton(
            status: status,
            onCatatan: onToggleExpanded,
            onNotOk: () => onStatusChanged(InspectionStatus.notOk),
            onOk: () => onStatusChanged(InspectionStatus.ok),
          ),

          // ── Detail Section (Note + Photo) ─────────────────────────────
          if (_showDetails) ...[
            const SizedBox(height: 10),
            InspectionProblemNoteField(
              controller: noteController,
              onChanged: onNoteChanged,
            ),
            const SizedBox(height: 8),
            InspectionPhotoBox(
              photoPath: item.photoPath,
              onTap: onPhotoTap,
            ),
          ],
        ],
      ),
    );
  }

  // ── Status Badge ──────────────────────────────────────────────────────────
  Widget _buildStatusBadge(InspectionStatus status) {
    final isOk = status == InspectionStatus.ok;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: isOk
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOk ? 'OK' : 'Tidak OK',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isOk ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}
