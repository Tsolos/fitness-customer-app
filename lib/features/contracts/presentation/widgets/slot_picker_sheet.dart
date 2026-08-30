import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/contracts_providers.dart';

/// Bottom sheet that lets the customer browse real availability (from
/// `POST /api/Guests/getSlotAvailability`) day by day and pick a slot,
/// instead of a free-form date/time picker that could land on a time the
/// gym has no capacity for.
class SlotPickerSheet extends ConsumerStatefulWidget {
  const SlotPickerSheet({super.key, required this.customerId, required this.companyId});

  final String customerId;
  final String companyId;

  @override
  ConsumerState<SlotPickerSheet> createState() => _SlotPickerSheetState();
}

class _SlotPickerSheetState extends ConsumerState<SlotPickerSheet> {
  late DateTime _selectedDay;

  static DateTime get _earliestDay {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _earliestDay;
  }

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: _earliestDay,
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _selectedDay = DateTime(picked.year, picked.month, picked.day));
  }

  @override
  Widget build(BuildContext context) {
    final slotsAsync = ref.watch(
      slotAvailabilityProvider(
        customerId: widget.customerId,
        branchId: widget.companyId,
        startDate: _selectedDay,
        days: 1,
      ),
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Επιλογή ώρας', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _selectedDay.isAfter(_earliestDay)
                      ? () => setState(() => _selectedDay = _selectedDay.subtract(const Duration(days: 1)))
                      : null,
                ),
                TextButton.icon(
                  onPressed: _pickDay,
                  icon: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text(DateFormat('EEEE dd/MM/yyyy', 'el_GR').format(_selectedDay)),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => _selectedDay = _selectedDay.add(const Duration(days: 1))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120, maxHeight: 320),
              child: slotsAsync.when(
                loading: () => const LoadingIndicator(),
                error: (error, _) => ErrorView(message: error is Failure ? error.message : 'Κάτι πήγε στραβά.'),
                data: (slots) {
                  final available = slots.where((s) => s.isAvailable).toList();
                  if (available.isEmpty) {
                    return const Center(child: Text('Δεν υπάρχουν διαθέσιμες ώρες αυτή την ημέρα.'));
                  }
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final slot in available)
                          ActionChip(
                            label: Text(DateFormat('HH:mm').format(slot.dateTime)),
                            onPressed: () => Navigator.of(context).pop(slot.dateTime),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
