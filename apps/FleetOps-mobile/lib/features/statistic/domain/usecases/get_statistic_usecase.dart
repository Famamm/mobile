import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

import '../entities/statistic_entity.dart';
import '../repositories/statistic_repository.dart';

class GetStatisticUseCase implements UseCase<StatisticEntity, StatisticParams> {
  final StatisticRepository repository;

  GetStatisticUseCase(this.repository);

  @override
  Future<Either<Failure, StatisticEntity>> call(StatisticParams params) {
    return repository.getStatistic(month: params.month, year: params.year);
  }
}

class StatisticParams extends Equatable {
  final int month;
  final int year;

  const StatisticParams({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}
