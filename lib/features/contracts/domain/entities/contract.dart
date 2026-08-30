import 'package:equatable/equatable.dart';

import 'appointment.dart';

class Contract extends Equatable {
  const Contract({
    required this.id,
    required this.packageName,
    required this.packageColor,
    required this.signUpDate,
    required this.totalSessions,
    required this.paid,
    required this.completed,
    required this.euro,
    required this.appointments,
  });

  final String id;
  final String packageName;

  /// Hex color the company configured for this package (`Package.PackageColor`),
  /// e.g. `"#1E88E5"`. Falls back to the app's primary color if unparsable.
  final String? packageColor;
  final DateTime signUpDate;
  final int totalSessions;
  final bool paid;
  final bool completed;
  final double euro;
  final List<Appointment> appointments;

  /// The API has no separate "remaining sessions" field: booking an
  /// appointment consumes a session slot immediately (see
  /// `GuestsController.addAppointment`), and cancelling frees it back up.
  /// So remaining = total minus every non-cancelled appointment.
  int get remainingSessions {
    final used = appointments.where((a) => a.status != AppointmentStatus.canceled).length;
    return (totalSessions - used).clamp(0, totalSessions);
  }

  bool get isActive => !completed && remainingSessions > 0;

  double get usageRatio => totalSessions == 0 ? 0 : (totalSessions - remainingSessions) / totalSessions;

  @override
  List<Object?> get props => [
        id,
        packageName,
        packageColor,
        signUpDate,
        totalSessions,
        paid,
        completed,
        euro,
        appointments,
      ];
}
