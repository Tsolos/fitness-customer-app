import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/number_parsing.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/progress_entry.dart';
import '../providers/progress_providers.dart';

const _chartPalette = [
  Color(0xFF1E88E5),
  Color(0xFF26A69A),
  Color(0xFFFFA726),
  Color(0xFFEC407A),
  Color(0xFF7E57C2),
  Color(0xFF66BB6A),
];

/// One measurement type ("Βάρος", "Λίπος %", ...) pivoted across dates.
/// The API has no fixed field set (see [ProgressEntry]'s doc comment), so
/// we group by name and treat a type as chartable only if most of its
/// values parse as numbers.
class _Series {
  _Series(this.name);

  final String name;
  final List<MapEntry<DateTime, String>> raw = [];

  List<MapEntry<DateTime, double>> get numericPoints {
    final points = <MapEntry<DateTime, double>>[];
    for (final entry in raw) {
      final value = parseFlexibleDouble(entry.value);
      if (value != null) points.add(MapEntry(entry.key, value));
    }
    return points;
  }

  bool get isChartable => raw.isNotEmpty && numericPoints.length >= raw.length ~/ 2 && numericPoints.length >= 2;
}

List<_Series> _pivotByType(List<ProgressEntry> entries) {
  final byName = <String, _Series>{};
  for (final entry in entries) {
    for (final item in entry.values.entries) {
      final series = byName.putIfAbsent(item.key, () => _Series(item.key));
      series.raw.add(MapEntry(entry.date, item.value));
    }
  }
  return byName.values.toList();
}

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(progressEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Η πρόοδός μου')),
      body: entriesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: error is Failure ? error.message : 'Κάτι πήγε στραβά.',
          onRetry: () => ref.invalidate(progressEntriesProvider),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('Δεν υπάρχουν ακόμα καταχωρήσεις προόδου.'));
          }

          final series = _pivotByType(entries);
          final chartable = series.where((s) => s.isChartable).toList();
          final nonChartable = series.where((s) => !s.isChartable).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(progressEntriesProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (var i = 0; i < chartable.length; i++) ...[
                  _SeriesCard(series: chartable[i], color: _chartPalette[i % _chartPalette.length]),
                  const SizedBox(height: 20),
                ],
                if (nonChartable.isNotEmpty) _LatestValuesCard(series: nonChartable, entries: entries),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SeriesCard extends StatelessWidget {
  const _SeriesCard({required this.series, required this.color});

  final _Series series;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final points = series.numericPoints;
    final first = points.first.value;
    final last = points.last.value;
    final delta = double.parse((last - first).toStringAsFixed(1));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(series.name, style: Theme.of(context).textTheme.titleMedium)),
                Text(last.toStringAsFixed(1), style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            if (delta != 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '${delta > 0 ? '+' : ''}$delta από την πρώτη μέτρηση',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(height: 180, child: _LineChart(points: points, color: color)),
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.points, required this.color});

  final List<MapEntry<DateTime, double>> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final spots = [for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].value)];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: (points.length / 4).clamp(1, points.length).roundToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= points.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat('dd/MM').format(points[index].key),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => [
              for (final spot in touchedSpots)
                LineTooltipItem(spot.y.toStringAsFixed(1), TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.12)),
          ),
        ],
      ),
    );
  }
}

/// Non-numeric measurement types (free text, dates, yes/no, ...) can't be
/// charted — shown instead as a simple "latest value" list.
class _LatestValuesCard extends StatelessWidget {
  const _LatestValuesCard({required this.series, required this.entries});

  final List<_Series> series;
  final List<ProgressEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Τελευταίες καταχωρήσεις', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final s in series)
              if (s.raw.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(s.name)),
                      Text(s.raw.last.value, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
