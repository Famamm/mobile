import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/fuel_price_entity.dart';

abstract class FuelEvent extends Equatable {
  const FuelEvent();

  @override
  List<Object?> get props => [];
}

class LoadFuelPricesEvent extends FuelEvent {
  const LoadFuelPricesEvent();
}

class GetAllFuelsEvent extends FuelEvent {
  const GetAllFuelsEvent();
}

class GetFuelsByVehicleEvent extends FuelEvent {
  final String vehicleId;

  const GetFuelsByVehicleEvent(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}

class CreateFuelEvent extends FuelEvent {
  final int vehicleId;
  final int organizationId;
  final String fuelType;
  final double jmlLiter;
  final int odometerIsi;
  final String catatan;
  final File? fuelPhoto;

  const CreateFuelEvent({
    required this.vehicleId,
    required this.organizationId,
    required this.fuelType,
    required this.jmlLiter,
    required this.odometerIsi,
    this.catatan = '',
    this.fuelPhoto,
  });

  @override
  List<Object?> get props =>
      [vehicleId, organizationId, fuelType, jmlLiter, odometerIsi, catatan];
}

class DeleteFuelEvent extends FuelEvent {
  final String id;

  const DeleteFuelEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// States
abstract class FuelState extends Equatable {
  const FuelState();

  @override
  List<Object?> get props => [];
}

class FuelInitial extends FuelState {
  const FuelInitial();
}

class FuelLoading extends FuelState {
  const FuelLoading();
}

class FuelPricesLoaded extends FuelState {
  final List<FuelPriceEntity> prices;

  const FuelPricesLoaded(this.prices);

  @override
  List<Object?> get props => [prices];
}

class FuelCreateSuccess extends FuelState {
  const FuelCreateSuccess();
}

class FuelDeleteSuccess extends FuelState {
  const FuelDeleteSuccess();
}

class FuelError extends FuelState {
  final String message;

  const FuelError(this.message);

  @override
  List<Object?> get props => [message];
}
