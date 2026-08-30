import 'package:equatable/equatable.dart';

/// One bookable time slot, from `POST /api/Guests/getSlotAvailability`.
class AppointmentSlot extends Equatable {
  const AppointmentSlot({required this.dateTime, required this.isAvailable});

  final DateTime dateTime;
  final bool isAvailable;

  @override
  List<Object?> get props => [dateTime, isAvailable];
}
