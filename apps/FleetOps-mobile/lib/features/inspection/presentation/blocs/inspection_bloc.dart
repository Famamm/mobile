import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/features/inspection/domain/repositories/inspection_repository.dart';
import 'package:fleetops_mobile/features/inspection/domain/usecases/submit_inspection_usecase.dart';
import 'inspection_event.dart';
import 'inspection_state.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  final SubmitInspectionUseCase submitInspectionUseCase;
  final InspectionRepository inspectionRepository;

  InspectionBloc({
    required this.submitInspectionUseCase,
    required this.inspectionRepository,
  }) : super(const InspectionInitial()) {
    on<SubmitInspectionEvent>(_onSubmitInspection);
    on<UpdateInspectionEvent>(_onUpdateInspection);
    on<ResetInspectionEvent>(_onReset);
  }

  Future<void> _onSubmitInspection(
    SubmitInspectionEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(const InspectionLoading());

    final result = await submitInspectionUseCase(
      SubmitInspectionParams(
        vehicleId: event.vehicleId,
        driverId: event.driverId,
        items: event.items,
      ),
    );

    result.fold(
      (failure) => emit(InspectionError(failure: failure)),
      (success) => emit(const InspectionSuccess()),
    );
  }

  Future<void> _onUpdateInspection(
    UpdateInspectionEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(const InspectionLoading());
    try {
      await inspectionRepository.updateInspectionItems(
        event.inspectionId,
        event.vehicleId,
        event.driverId,
        event.items,
      );
      emit(const InspectionSuccess(message: 'Inspeksi berhasil diperbarui'));
    } catch (e) {
      emit(const InspectionInitial());
    }
  }

  Future<void> _onReset(
    ResetInspectionEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(const InspectionInitial());
  }
}
