import 'package:equatable/equatable.dart';

import '../../domain/entities/statistic_entity.dart';

abstract class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object> get props => [];
}

class StatisticInitial extends StatisticState {
  const StatisticInitial();
}

class StatisticLoading extends StatisticState {
  const StatisticLoading();
}

class StatisticLoaded extends StatisticState {
  final StatisticEntity statistic;

  const StatisticLoaded(this.statistic);

  @override
  List<Object> get props => [statistic];
}

class StatisticError extends StatisticState {
  final String message;

  const StatisticError(this.message);

  @override
  List<Object> get props => [message];
}
