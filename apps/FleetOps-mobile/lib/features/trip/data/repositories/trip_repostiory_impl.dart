import 'package:fleetops_mobile/features/trip/data/data_sources/trip_remote_data_source.dart';
import 'package:fleetops_mobile/features/trip/data/models/cancel_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/data/models/start_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/data/models/stop_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/data/models/get_detail_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/data/models/get_active_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/domain/repositories/trip_repository.dart';

import '../models/demage_report_dto.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl({required this.remoteDataSource});

  @override
  Future<int> startTrip(StartTripDTO dto) async {
    return await remoteDataSource.startTrip(dto);
  }

  @override
  Future<void> stopTrip(int tripId, StopTripDTO dto) async {
    return await remoteDataSource.stopTrip(tripId, dto);
  }

  @override
  Future<void> cancelTrip(int tripId, CancelTripDTO dto) async {
    return await remoteDataSource.cancelTrip(tripId, dto);
  }

  @override
  Future<GetDetailTripDTO> getTripDetail(int tripId) async {
    return await remoteDataSource.getTripDetail(tripId);
  }

  @override
  Future<GetActiveTripDTO?> getActiveTrip(int driverId) async {
    return await remoteDataSource.getActiveTrip(driverId);
  }

  @override
  Future<void> submitDamageReport(DamageReportDTO dto) async {
    return await remoteDataSource.submitDamageReport(dto);
  }
}
