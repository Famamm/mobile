import 'package:equatable/equatable.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object> get props => [];
}

class LoadStatisticEvent extends StatisticEvent {
  final int month;
  final int year;

  const LoadStatisticEvent({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}
