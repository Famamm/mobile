import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/statistic_entity.dart';

abstract class StatisticRepository {
  Future<Either<Failure, StatisticEntity>> getStatistic({
    required int month,
    required int year,
  });
}
