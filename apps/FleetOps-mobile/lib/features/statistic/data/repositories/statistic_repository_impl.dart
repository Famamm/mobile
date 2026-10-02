import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../../domain/entities/statistic_entity.dart';
import '../../domain/repositories/statistic_repository.dart';
import '../data_sources/statistic_remote_data_source.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  final StatisticRemoteDataSource remoteDataSource;

  StatisticRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StatisticEntity>> getStatistic({
    required int month,
    required int year,
  }) async {
    try {
      return Right(
        await remoteDataSource.getStatistic(month: month, year: year),
      );
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
