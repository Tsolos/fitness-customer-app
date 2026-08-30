import 'package:equatable/equatable.dart';

/// `GuestsController.getAllMeasurements` doesn't return fixed fields like
/// "weight" — each company defines its own measurement template
/// (`Template`/`TemplateItem`), so a session's measurement is just a
/// `{date, values: [{type: itemName, value: formattedString}]}` bag. We
/// keep it as a name→formatted-value map and let the presentation layer
/// decide which items are numeric enough to chart.
class ProgressEntry extends Equatable {
  const ProgressEntry({required this.date, required this.values});

  final DateTime date;
  final Map<String, String> values;

  @override
  List<Object?> get props => [date, values];
}
