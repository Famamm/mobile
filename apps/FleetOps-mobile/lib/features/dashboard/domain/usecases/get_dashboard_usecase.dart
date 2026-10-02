import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase implements UseCase<DashboardEntity, DashboardParams> {
  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardEntity>> call(DashboardParams params) {
    return repository.getDashboard();
  }
}

class DashboardParams extends Equatable {
  const DashboardParams();

  @override
  List<Object> get props => [];
}
