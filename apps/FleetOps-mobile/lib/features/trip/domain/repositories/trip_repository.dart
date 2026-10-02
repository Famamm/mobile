import '../../data/models/cancel_trip_dto.dart';
import '../../data/models/demage_report_dto.dart';
import '../../data/models/get_active_trip_dto.dart';
import '../../data/models/get_detail_trip_dto.dart';
import '../../data/models/start_trip_dto.dart';
import '../../data/models/stop_trip_dto.dart';

abstract interface class TripRepository {
  Future<int> startTrip(StartTripDTO dto);

  Future<void> stopTrip(int tripId, StopTripDTO dto);

  Future<GetDetailTripDTO> getTripDetail(int tripId);

  Future<void> cancelTrip(int tripId, CancelTripDTO dto);

  Future<GetActiveTripDTO?> getActiveTrip(int driverId);

  Future<void> submitDamageReport(DamageReportDTO dto);
}
