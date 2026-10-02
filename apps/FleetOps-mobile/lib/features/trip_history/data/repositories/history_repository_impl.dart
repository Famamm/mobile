import 'package:fleetops_mobile/features/trip_history/data/data_sources/history_data_source.dart';
import 'package:fleetops_mobile/features/trip_history/data/models/get_trip_dto.dart';
import 'package:fleetops_mobile/features/trip_history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<GetTripDTO>> getTripHistory(int driverId) async {
    return await remoteDataSource.getTripHistory(driverId);
  }
}
