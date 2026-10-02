import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/damage_report_mapping.dart';
import '../../data/models/demage_report_dto.dart';
import '../../domain/repositories/trip_repository.dart';
import 'damage_report_event.dart';
import 'damage_report_state.dart';

class DamageReportBloc extends Bloc<DamageReportEvent, DamageReportState> {
  final TripRepository repository;

  DamageReportBloc({required this.repository}) : super(DamageReportInitial()) {
    on<SubmitDamageReport>(_onSubmit);
    on<ResetDamageReport>((_, emit) => emit(DamageReportInitial()));
  }

  Future<void> _onSubmit(
    SubmitDamageReport event,
    Emitter<DamageReportState> emit,
  ) async {
    emit(DamageReportLoading());
    try {
      final dto = DamageReportDTO(
        tripId: event.tripId,
        driverId: event.driverId,
        vehicleId: event.vehicleId,
        operationalStatus: DamageReportMapping.getOperationalStatus(
          event.operationalStatus,
        ),
        severity: DamageReportMapping.getSeverity(event.severity),
        damageType: event.damageType,
        note: event.note,
        location: event.location,
        odometer: event.odometer,
        image: event.image,
      );
      await repository.submitDamageReport(dto);
      emit(DamageReportSuccess());
    } catch (e) {
      emit(DamageReportError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
