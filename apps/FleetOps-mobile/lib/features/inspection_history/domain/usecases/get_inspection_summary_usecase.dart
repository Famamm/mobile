import '../entities/inspection_history_summary_entity.dart';
import '../repositories/inspection_history_repository.dart';

class GetInspectionSummaryUseCase {
  final InspectionHistoryRepository repository;

  const GetInspectionSummaryUseCase(this.repository);

  Future<InspectionHistorySummaryEntity> call() {
    return repository.getSummary();
  }
}
