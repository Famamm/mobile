import '../models/demage_report_dto.dart';
import '../models/start_trip_dto.dart';
import '../models/stop_trip_dto.dart';
import '../models/cancel_trip_dto.dart';
import '../models/get_detail_trip_dto.dart';
import '../models/get_active_trip_dto.dart';

abstract interface class TripRemoteDataSource {
  Future<int> startTrip(StartTripDTO dto);

  Future<void> stopTrip(int tripId, StopTripDTO dto);

  Future<GetDetailTripDTO> getTripDetail(int tripId);

  Future<void> cancelTrip(int tripId, CancelTripDTO dto);

  Future<GetActiveTripDTO?> getActiveTrip(int driverId);

  Future<void> submitDamageReport(DamageReportDTO dto);
}
