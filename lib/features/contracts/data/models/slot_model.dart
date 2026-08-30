import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/appointment_slot.dart';

/// `SlotAvailabilityDto` — note the server uses PascalCase `SlotTime`
/// (not the usual camelCase), so both castings are checked defensively.
class SlotModel {
  const SlotModel({required this.dateTime, required this.isAvailable});

  final DateTime dateTime;
  final bool isAvailable;

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      dateTime: parseDate(anyKey(json, ['SlotTime', 'slotTime'])),
      isAvailable: parseBool(anyKey(json, ['isAvailable', 'IsAvailable'])),
    );
  }

  AppointmentSlot toEntity() => AppointmentSlot(dateTime: dateTime, isAvailable: isAvailable);
}
