import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';
import 'package:fleetops_mobile/features/inspection/domain/repositories/inspection_repository.dart';

class SubmitInspectionUseCase implements UseCase<void, SubmitInspectionParams> {
  final InspectionRepository repository;

  SubmitInspectionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitInspectionParams params) async {
    try {
      await repository.submitInspection(
        params.vehicleId,
        params.driverId,
        params.items,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class SubmitInspectionParams extends Equatable {
  final int vehicleId;
  final int driverId;
  final List<InspectionItemEntity> items;

  const SubmitInspectionParams({
    required this.vehicleId,
    required this.driverId,
    required this.items,
  });

  @override
  List<Object?> get props => [vehicleId, driverId, items];
}
