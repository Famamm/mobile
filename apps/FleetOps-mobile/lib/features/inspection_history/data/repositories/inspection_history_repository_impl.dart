import '../../domain/entities/inspection_history_entity.dart';
import '../../domain/entities/inspection_history_summary_entity.dart';
import '../../domain/repositories/inspection_history_repository.dart';
import '../data_sources/inspection_history_remote_data_source.dart';

class InspectionHistoryRepositoryImpl implements InspectionHistoryRepository {
  final InspectionHistoryRemoteDataSource remoteDataSource;

  const InspectionHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<InspectionHistorySummaryEntity> getSummary() {
    return remoteDataSource.getSummary();
  }

  @override
  Future<List<InspectionHistoryEntity>> getHistories({
    String? searchQuery,
    InspectionHistoryStatus? filterStatus,
  }) {
    return remoteDataSource.getInspectionHistories(
      searchQuery: searchQuery,
      filterStatus: filterStatus,
    );
  }
}
