/// Small defensive JSON helpers for parsing loosely-typed ASP.NET Core
/// responses (nullable fields, numbers that may arrive as int or double,
/// dates without a fixed key casing, etc.) without each model re-writing
/// the same null-checks.
DateTime? parseNullableDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

DateTime parseDate(dynamic value, {DateTime? fallback}) {
  return parseNullableDate(value) ?? fallback ?? DateTime.now();
}

double parseDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? fallback;
}

int parseInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? fallback;
}

String parseString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}

String? parseNullableString(dynamic value) {
  if (value == null) return null;
  final s = value.toString();
  return s.isEmpty ? null : s;
}

bool parseBool(dynamic value, {bool fallback = false}) {
  if (value == null) return fallback;
  if (value is bool) return value;
  return value.toString().toLowerCase() == 'true';
}

/// Looks a key up trying several possible casings — some of this API's
/// DTOs deviate from the default camelCase policy (e.g. `SlotAvailabilityDto.SlotTime`).
dynamic anyKey(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key)) return json[key];
  }
  return null;
}
