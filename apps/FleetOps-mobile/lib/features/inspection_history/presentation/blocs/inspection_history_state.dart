import '../../domain/entities/inspection_history_entity.dart';
import '../../domain/entities/inspection_history_summary_entity.dart';

enum InspectionHistoryStatus2 { initial, loading, loaded, failure }

class InspectionHistoryState {
  final InspectionHistoryStatus2 status;
  final InspectionHistorySummaryEntity? summary;
  final List<InspectionHistoryEntity> histories;
  final String searchQuery;
  final InspectionHistoryStatus? filterStatus;
  final String? errorMessage;

  const InspectionHistoryState({
    this.status = InspectionHistoryStatus2.initial,
    this.summary,
    this.histories = const [],
    this.searchQuery = '',
    this.filterStatus,
    this.errorMessage,
  });

  bool get isEmpty => histories.isEmpty;

  InspectionHistoryState copyWith({
    InspectionHistoryStatus2? status,
    InspectionHistorySummaryEntity? summary,
    List<InspectionHistoryEntity>? histories,
    String? searchQuery,
    InspectionHistoryStatus? filterStatus,
    String? errorMessage,
    bool clearFilter = false,
    bool clearError = false,
  }) {
    return InspectionHistoryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      histories: histories ?? this.histories,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
