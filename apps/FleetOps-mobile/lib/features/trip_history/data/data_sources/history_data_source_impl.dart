import 'package:core/core.dart';
import 'package:fleetops_mobile/features/trip_history/data/models/get_trip_dto.dart';
import 'history_data_source.dart';

class HistoryDataSourceImpl implements HistoryDataSource {
  final HttpService httpService;

  HistoryDataSourceImpl({required this.httpService});

  @override
  Future<List<GetTripDTO>> getTripHistory(int driverId) async {
    try {
      final response = await httpService.get(
        ApiConfig.driverGetTripsHistoryEndpoint.replaceFirst(
          '{driverId}',
          driverId.toString(),
        ),
      );
      if (response == null || response.isEmpty) {
        return [];
      }
      final trips = (response as List)
          .map((json) => GetTripDTO.fromJson(json as Map<String, dynamic>))
          .toList();
      return trips;
    } catch (e) {
      final errorMessage = e.toString();

      if (errorMessage.contains('HTTP 404') ||
          errorMessage.contains('no trips found')) {
        print('No trips found for driverId: $driverId. Returning empty list.');
        return [];
      } else {
        print('[HISTORY] Error fetching trip history: $e');
        throw Exception('Failed to fetch trip history: $e');
      }
    }
  }
}
