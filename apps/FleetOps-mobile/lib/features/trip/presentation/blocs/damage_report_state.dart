abstract class DamageReportState {}

class DamageReportInitial extends DamageReportState {}
class DamageReportLoading extends DamageReportState {}
class DamageReportSuccess extends DamageReportState {}

class DamageReportError extends DamageReportState {
  final String message;
  DamageReportError(this.message);
}