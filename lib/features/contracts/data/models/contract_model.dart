import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/contract.dart';
import 'appointment_model.dart';

/// Parses one element of `GET /api/Guests/getGuestContracts/{customerID}`'s
/// response — see `GuestsController.getGuestContracts`'s `Select(...)`.
class ContractModel {
  const ContractModel({
    required this.id,
    required this.packageName,
    required this.packageColor,
    required this.signUpDate,
    required this.contractSessions,
    required this.paid,
    required this.completed,
    required this.euro,
    required this.appointments,
  });

  final String id;
  final String packageName;
  final String? packageColor;
  final DateTime signUpDate;
  final int contractSessions;
  final bool paid;
  final bool completed;
  final double euro;
  final List<AppointmentModel> appointments;

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    final package = json['package'] as Map<String, dynamic>? ?? const {};
    final rawAppointments = json['appointments'] as List<dynamic>? ?? const [];

    return ContractModel(
      id: parseString(json['contractID']),
      packageName: parseString(package['name'], fallback: 'Πακέτο'),
      packageColor: parseNullableString(package['color']),
      signUpDate: parseDate(json['signUpDate']),
      contractSessions: parseInt(json['contractSessions']),
      paid: parseBool(json['paid']),
      completed: parseBool(json['completed']),
      euro: parseDouble(json['euro']),
      appointments: rawAppointments
          .whereType<Map<String, dynamic>>()
          .map(AppointmentModel.fromJson)
          .toList(),
    );
  }

  Contract toEntity() {
    return Contract(
      id: id,
      packageName: packageName,
      packageColor: packageColor,
      signUpDate: signUpDate,
      totalSessions: contractSessions,
      paid: paid,
      completed: completed,
      euro: euro,
      appointments: appointments.map((a) => a.toEntity(contractId: id)).toList(),
    );
  }
}
