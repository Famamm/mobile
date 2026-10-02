import '../../domain/entities/inspection_history_entity.dart';

abstract class InspectionHistoryEvent {
  const InspectionHistoryEvent();
}

class InspectionHistoryStarted extends InspectionHistoryEvent {
  const InspectionHistoryStarted();
}

class InspectionHistorySearchChanged extends InspectionHistoryEvent {
  final String query;
  const InspectionHistorySearchChanged(this.query);
}

class InspectionHistoryFilterChanged extends InspectionHistoryEvent {
  final InspectionHistoryStatus? status;
  const InspectionHistoryFilterChanged(this.status);
}

class InspectionHistoryRefreshed extends InspectionHistoryEvent {
  const InspectionHistoryRefreshed();
}
