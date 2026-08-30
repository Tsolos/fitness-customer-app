import 'package:equatable/equatable.dart';

/// Mirrors `gym_api.Models.Status` — declaration order is the wire value
/// (`Pending = 0, Overtime = 1, Completed = 2, Canceled = 3`).
enum AppointmentStatus { pending, overtime, completed, canceled }

class Appointment extends Equatable {
  const Appointment({
    required this.id,
    required this.contractId,
    required this.dateTime,
    required this.status,
    this.trainerName,
    this.hasMeasurement = false,
  });

  final String id;
  final String contractId;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String? trainerName;
  final bool hasMeasurement;

  bool get isPast => dateTime.isBefore(DateTime.now());

  /// The API doesn't enforce this server-side (`changeAppointmentDate` /
  /// `cancelAppointment` accept any status), so the client is the only
  /// place this rule is applied: only a still-pending, future appointment
  /// may be rescheduled or cancelled.
  bool get canModify => status == AppointmentStatus.pending && !isPast;

  bool get canRestore => status == AppointmentStatus.canceled && !isPast;

  Appointment copyWith({DateTime? dateTime, AppointmentStatus? status}) {
    return Appointment(
      id: id,
      contractId: contractId,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      trainerName: trainerName,
      hasMeasurement: hasMeasurement,
    );
  }

  @override
  List<Object?> get props => [id, contractId, dateTime, status, trainerName, hasMeasurement];
}
