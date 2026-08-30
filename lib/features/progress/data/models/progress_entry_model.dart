import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/progress_entry.dart';

class ProgressEntryModel {
  const ProgressEntryModel({required this.date, required this.values});

  final DateTime date;
  final Map<String, String> values;

  factory ProgressEntryModel.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'] as List<dynamic>? ?? const [];
    final values = <String, String>{};
    for (final entry in rawValues) {
      if (entry is! Map<String, dynamic>) continue;
      final type = parseNullableString(entry['type']);
      if (type == null) continue;
      values[type] = parseString(entry['value']);
    }
    return ProgressEntryModel(date: _parseServerDate(parseString(json['date'])), values: values);
  }

  ProgressEntry toEntity() => ProgressEntry(date: date, values: values);
}

/// `Date.Date.ToString("d/M/yy")` — day/month unpadded, 2-digit year,
/// e.g. "18/8/26" or "3/1/26". Parsed manually instead of via `DateFormat`
/// to avoid any locale ambiguity around day/month order.
DateTime _parseServerDate(String value) {
  final parts = value.split('/');
  if (parts.length != 3) return DateTime.now();
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final twoDigitYear = int.tryParse(parts[2]);
  if (day == null || month == null || twoDigitYear == null) return DateTime.now();
  final year = twoDigitYear + (twoDigitYear < 100 ? 2000 : 0);
  return DateTime(year, month, day);
}
