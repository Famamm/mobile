import 'package:equatable/equatable.dart';

class DailyActivityEntity extends Equatable {
  final DateTime date;
  final int tripCount;

  const DailyActivityEntity({required this.date, required this.tripCount});

  @override
  List<Object> get props => [date, tripCount];
}
