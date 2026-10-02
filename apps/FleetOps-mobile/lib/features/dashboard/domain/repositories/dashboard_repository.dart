import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardEntity>> getDashboard();
}
