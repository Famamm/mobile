import 'package:fleetops_mobile/features/trip/data/models/cancel_trip_dto.dart';
import 'package:core/core.dart';

import '../models/demage_report_dto.dart';
import '../models/start_trip_dto.dart';
import '../models/stop_trip_dto.dart';
import '../models/get_detail_trip_dto.dart';
import '../models/get_active_trip_dto.dart';
import 'trip_remote_data_source.dart';

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final HttpService httpService;

  TripRemoteDataSourceImpl({required this.httpService});

  @override
  Future<int> startTrip(StartTripDTO dto) async {
    final response = await httpService.post(
      ApiConfig.driverStartTripEndpoint,
      dto.toJson(),
    );

    // Handle { "tripId": ... } langsung atau dibungkus { "data": { "tripId": ... } }
    final payload = response.containsKey('data') && response['data'] is Map
        ? response['data'] as Map<String, dynamic>
        : response;

    final rawId = payload['tripId'] ?? payload['id'];
    if (rawId == null) {
      throw Exception('Response tidak mengandung tripId: $response');
    }
    return (rawId as num).toInt();
  }

  @override
  Future<void> stopTrip(int tripId, StopTripDTO dto) async {
    final endpoint = ApiConfig.driverStopTripEndpoint.replaceAll(
      '{tripId}',
      tripId.toString(),
    );

    if (dto.dokumentasiFoto != null && dto.dokumentasiFoto!.existsSync()) {
      await httpService.patchWithFile(
        endpoint,
        {
          'driverId': dto.driverId.toString(),
          'vehicleId': dto.vehicleId.toString(),
          'lokasiAkhir': dto.lokasiAkhir,
          'odometerAkhir': dto.odometerAkhir?.toString() ?? '',
          'kordAkhirLatitude': dto.kordAkhirLatitude?.toString() ?? '',
          'kordAkhirLongitude': dto.kordAkhirLongitude?.toString() ?? '',
          'catatan': dto.catatan,
        },
        dto.dokumentasiFoto!,
        'Image',
      );
    } else {
      await httpService.post(endpoint, dto.toJson());
    }
  }

  @override
  Future<GetDetailTripDTO> getTripDetail(int tripId) async {
    final endpoint = ApiConfig.driverGetTripByIdEndpoint.replaceAll(
      '{tripId}',
      tripId.toString(),
    );

    final response = await httpService.get(endpoint);

    final data =
        response is Map<String, dynamic> && response.containsKey('data')
            ? response['data'] as Map<String, dynamic>
            : response as Map<String, dynamic>;

    return GetDetailTripDTO.fromJson(data);
  }

  @override
  Future<void> cancelTrip(int tripId, CancelTripDTO dto) async {
    final endpoint = ApiConfig.driverCancelTripEndpoint.replaceAll(
      '{tripId}',
      tripId.toString(),
    );

    await httpService.patch(endpoint, dto.toJson());
  }

  @override
  Future<GetActiveTripDTO?> getActiveTrip(int driverId) async {
    final endpoint = ApiConfig.driverGetActiveTripByDriverEndpoint.replaceAll(
      '{driverId}',
      driverId.toString(),
    );

    try {
      final response = await httpService.get(endpoint);
      if (response == null) return null;
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      return GetActiveTripDTO.fromJson(data);
    } catch (e) {
      // 204 NoContent atau error lain — tidak ada trip aktif
      return null;
    }
  }

  @override
  Future<void> submitDamageReport(DamageReportDTO dto) async {
    final endpoint = ApiConfig.driverDamageReportEndpoint.replaceAll(
      '{tripId}',
      dto.tripId.toString(),
    );

    if (dto.image != null && dto.image!.existsSync()) {
      await httpService.postWithFile(
        endpoint,
        dto.toMultipartFields(),
        dto.image!,
        'Image',
      );
    } else {
      await httpService.post(endpoint, dto.toJson());
    }
  }
}
