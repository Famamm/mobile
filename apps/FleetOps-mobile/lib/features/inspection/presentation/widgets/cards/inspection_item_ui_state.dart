import 'package:flutter/material.dart';
import 'package:fleetops_mobile/features/inspection/presentation/widgets/buttons/inspection_status_button.dart';

class InspectionItemUiState {
  InspectionStatus status;
  final TextEditingController noteController;
  String? photoPath;
  bool showExpanded;

  InspectionItemUiState()
      : status = InspectionStatus.none,
        noteController = TextEditingController(),
        showExpanded = false;

  void dispose() {
    noteController.dispose();
  }
}
