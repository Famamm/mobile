import '../entities/inspection_history_entity.dart';
import '../entities/inspection_history_summary_entity.dart';

abstract class InspectionHistoryRepository {
  Future<InspectionHistorySummaryEntity> getSummary();

  Future<List<InspectionHistoryEntity>> getHistories({
    String? searchQuery,
    InspectionHistoryStatus? filterStatus,
  });
}
