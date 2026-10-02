import '../entities/inspection_history_entity.dart';
import '../repositories/inspection_history_repository.dart';

class GetInspectionHistoriesUseCase {
  final InspectionHistoryRepository repository;

  const GetInspectionHistoriesUseCase(this.repository);

  Future<List<InspectionHistoryEntity>> call({
    String? searchQuery,
    InspectionHistoryStatus? filterStatus,
  }) {
    return repository.getHistories(
      searchQuery: searchQuery,
      filterStatus: filterStatus,
    );
  }
}
