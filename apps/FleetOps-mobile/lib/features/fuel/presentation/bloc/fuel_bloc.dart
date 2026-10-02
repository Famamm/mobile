import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_fuel_usecase.dart';
import '../../domain/usecases/delete_fuel_usecase.dart';
import '../../domain/usecases/get_fuel_prices_usecase.dart';
import 'fuel_event.dart';

class FuelBloc extends Bloc<FuelEvent, FuelState> {
  final GetFuelPricesUsecase getFuelPricesUsecase;
  final CreateFuelUsecase createFuelUsecase;
  final DeleteFuelUsecase deleteFuelUsecase;

  FuelBloc({
    required this.getFuelPricesUsecase,
    required this.createFuelUsecase,
    required this.deleteFuelUsecase,
  }) : super(const FuelInitial()) {
    on<LoadFuelPricesEvent>(_onLoadFuelPrices);
    on<CreateFuelEvent>(_onCreateFuel);
    on<DeleteFuelEvent>(_onDeleteFuel);
  }

  Future<void> _onLoadFuelPrices(
    LoadFuelPricesEvent event,
    Emitter<FuelState> emit,
  ) async {
    emit(const FuelLoading());
    final result = await getFuelPricesUsecase();
    result.fold(
      (failure) => emit(FuelError(failure.message)),
      (prices) => emit(FuelPricesLoaded(prices)),
    );
  }

  Future<void> _onCreateFuel(
    CreateFuelEvent event,
    Emitter<FuelState> emit,
  ) async {
    emit(const FuelLoading());
    final result = await createFuelUsecase(
      vehicleId: event.vehicleId,
      organizationId: event.organizationId,
      fuelType: event.fuelType,
      jmlLiter: event.jmlLiter,
      odometerIsi: event.odometerIsi,
      catatan: event.catatan,
      fuelPhoto: event.fuelPhoto,
    );
    result.fold(
      (failure) => emit(FuelError(failure.message)),
      (_) => emit(const FuelCreateSuccess()),
    );
  }

  Future<void> _onDeleteFuel(
    DeleteFuelEvent event,
    Emitter<FuelState> emit,
  ) async {
    emit(const FuelLoading());
    final result = await deleteFuelUsecase(event.id);
    result.fold(
      (failure) => emit(FuelError(failure.message)),
      (_) => emit(const FuelDeleteSuccess()),
    );
  }
}
