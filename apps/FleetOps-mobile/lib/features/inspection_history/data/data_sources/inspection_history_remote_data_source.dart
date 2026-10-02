import 'package:core/core.dart';
import 'package:fleetops_mobile/injection_container.dart';

import '../../domain/entities/inspection_history_entity.dart';
import '../models/inspection_history_model.dart';
import '../models/inspection_history_summary_model.dart';

abstract class InspectionHistoryRemoteDataSource {
  Future<InspectionHistorySummaryModel> getSummary();

  Future<List<InspectionHistoryModel>> getInspectionHistories({
    String? searchQuery,
    InspectionHistoryStatus? filterStatus,
  });
}

class InspectionHistoryRemoteDataSourceImpl
    implements InspectionHistoryRemoteDataSource {
  final HttpService httpService;

  InspectionHistoryRemoteDataSourceImpl({required this.httpService});

  @override
  Future<InspectionHistorySummaryModel> getSummary() async {
    // Summary dihitung dari data histories yang sudah di-load
    // Nanti bisa diganti endpoint khusus summary jika tersedia
    final histories = await getInspectionHistories();
    final total = histories.length;
    final selesai = histories
        .where((e) => e.status == InspectionHistoryStatus.selesai)
        .length;
    final percent = total == 0 ? 0 : ((selesai / total) * 100).round();
    return InspectionHistorySummaryModel(
      totalInspeksi: total,
      kelengkapanInspeksiPercent: percent,
    );
  }

  @override
  Future<List<InspectionHistoryModel>> getInspectionHistories({
    String? searchQuery,
    InspectionHistoryStatus? filterStatus,
  }) async {
    final tokenService = sl<TokenService>();
    final driverId = tokenService.getDriverId() ?? 0;
    final response = await httpService.get(
      ApiConfig.driverGetInspectionsByDriverEndpoint.replaceFirst(
        '{driverId}',
        driverId.toString(),
      ),
    );

    List<dynamic> rawList;
    if (response is Map && response['inspections'] != null) {
      rawList = response['inspections'] as List<dynamic>;
    } else if (response is List) {
      rawList = response;
    } else {
      rawList = [];
    }

    var results = rawList
        .map((e) => InspectionHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Filter by status
    if (filterStatus != null) {
      results = results.where((e) => e.status == filterStatus).toList();
    }

    // Filter by search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      results = results.where((e) {
        final tanggal =
            '${e.date.day.toString().padLeft(2, '0')}-${e.date.month.toString().padLeft(2, '0')}-${e.date.year}';
        return e.vehicleName.toLowerCase().contains(query) ||
            e.plateNumber.toLowerCase().contains(query) ||
            tanggal.contains(query);
      }).toList();
    }

    return results;
  }
}
