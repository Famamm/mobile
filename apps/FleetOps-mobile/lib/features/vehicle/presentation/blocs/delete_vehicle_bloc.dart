import 'package:bloc/bloc.dart';
import 'package:core/core.dart';

import 'package:fleetops_mobile/features/vehicle/data/data_sources/vehicle_remote_data_source_impl.dart';
import 'package:fleetops_mobile/features/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'package:fleetops_mobile/features/vehicle/domain/repositories/vehicle_repository.dart';
import 'package:fleetops_mobile/features/vehicle/presentation/blocs/delete_vehicle_event.dart';
import 'package:fleetops_mobile/features/vehicle/presentation/blocs/delete_vehicle_state.dart';

class VehicleDeleteBloc extends Bloc<VehicleDeleteEvent, VehicleDeleteState> {
  final VehicleRepository vehicleRepository;

  VehicleDeleteBloc({required this.vehicleRepository})
    : super(VehicleDeleteInitial()) {
    on<DeleteVehicleRequested>(_onDeleteVehicleRequested);
    on<ResetDeleteStatus>(_onResetDeleteStatus);
  }

  factory VehicleDeleteBloc.create({required HttpService httpService}) {
    final remoteDataSource = VehicleRemoteDataSourceImpl(
      httpService: httpService,
    );
    final repository = VehicleRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    return VehicleDeleteBloc(vehicleRepository: repository);
  }

  Future<void> _onDeleteVehicleRequested(
    DeleteVehicleRequested event,
    Emitter<VehicleDeleteState> emit,
  ) async {
    emit(VehicleDeleteLoading());

    try {
      await vehicleRepository.deleteVehicle(event.vehicleId);
      emit(VehicleDeleteSuccess(vehicleId: event.vehicleId));
    } catch (e) {
      emit(VehicleDeleteFailure(error: e.toString()));
    }
  }

  Future<void> _onResetDeleteStatus(
    ResetDeleteStatus event,
    Emitter<VehicleDeleteState> emit,
  ) async {
    emit(VehicleDeleteInitial());
  }
}
