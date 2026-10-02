import 'package:fleetops_mobile/features/trip_history/data/models/get_trip_dto.dart';

abstract interface class HistoryDataSource {
  Future<List<GetTripDTO>> getTripHistory(int driverId);
}
