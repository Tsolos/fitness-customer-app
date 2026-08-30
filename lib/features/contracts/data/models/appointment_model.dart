import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/appointment.dart';

/// Parses both shapes the API returns:
/// - the slim projection from `getGuestContracts` (`appointmentID, date,
///   status, hasMeasurement, trainer: {familyName, givenName}`)
/// - the full `Appointment` entity from `addAppointment` /
///   `changeAppointmentDate` / `cancelAppointment` / `restoreAppointment`
///   (same field names, plus a lot of nav-property noise we ignore).
class AppointmentModel {
  const AppointmentModel({
    required this.id,
    required this.dateTime,
    required this.status,
    this.trainerName,
    this.hasMeasurement = false,
  });

  final String id;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String? trainerName;
  final bool hasMeasurement;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final trainer = json['trainer'] as Map<String, dynamic>?;
    String? trainerName;
    if (trainer != null) {
      final given = parseNullableString(trainer['givenName']);
      final family = parseNullableString(trainer['familyName']);
      final full = [given, family].whereType<String>().join(' ').trim();
      trainerName = full.isEmpty ? null : full;
    }

    return AppointmentModel(
      id: parseString(json['appointmentID']),
      dateTime: parseDate(json['date']),
      status: _statusFromWire(json['status']),
      trainerName: trainerName,
      hasMeasurement: parseBool(json['hasMeasurement']),
    );
  }

  Appointment toEntity({required String contractId}) {
    return Appointment(
      id: id,
      contractId: contractId,
      dateTime: dateTime,
      status: status,
      trainerName: trainerName,
      hasMeasurement: hasMeasurement,
    );
  }
}

/// `gym_api.Models.Status`: Pending = 0, Overtime = 1, Completed = 2, Canceled = 3.
AppointmentStatus _statusFromWire(dynamic value) {
  switch (parseInt(value)) {
    case 1:
      return AppointmentStatus.overtime;
    case 2:
      return AppointmentStatus.completed;
    case 3:
      return AppointmentStatus.canceled;
    case 0:
    default:
      return AppointmentStatus.pending;
  }
}
