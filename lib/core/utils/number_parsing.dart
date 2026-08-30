/// Parses a formatted number string whose decimal separator could be
/// either `.` or `,` — the API formats measurement values server-side with
/// `.ToString("N2")` / `.ToString("N0")`, and we don't control (or fully
/// know) the server's culture setting.
///
/// - Both `.` and `,` present: the later one is the decimal separator,
///   the earlier one is a thousands separator (e.g. "1.234,56" or "1,234.56").
/// - Only `,` present: treated as the decimal separator ("82,50" → 82.5).
/// - Only `.` present: treated as the decimal separator ("82.50" → 82.5).
double? parseFlexibleDouble(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;

  final lastComma = trimmed.lastIndexOf(',');
  final lastDot = trimmed.lastIndexOf('.');

  String normalized;
  if (lastComma != -1 && lastDot != -1) {
    if (lastComma > lastDot) {
      normalized = trimmed.replaceAll('.', '').replaceAll(',', '.');
    } else {
      normalized = trimmed.replaceAll(',', '');
    }
  } else if (lastComma != -1) {
    normalized = trimmed.replaceAll(',', '.');
  } else {
    normalized = trimmed;
  }

  return double.tryParse(normalized);
}
