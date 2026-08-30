import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either_x.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/contract.dart';
import '../providers/contracts_providers.dart';
import '../widgets/slot_picker_sheet.dart';

class ContractsScreen extends ConsumerWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractsAsync = ref.watch(contractsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Συμβόλαια & Ραντεβού')),
      floatingActionButton: contractsAsync.maybeWhen(
        data: (contracts) => FloatingActionButton.extended(
          onPressed: () => _openCreateAppointmentDialog(context, ref, contracts),
          icon: const Icon(Icons.add),
          label: const Text('Νέο ραντεβού'),
        ),
        orElse: () => null,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(contractsProvider);
          await ref.read(contractsProvider.future);
        },
        child: contractsAsync.when(
          loading: () => const LoadingIndicator(),
          error: (error, _) => ErrorView(
            message: error is Failure ? error.message : 'Κάτι πήγε στραβά.',
            onRetry: () => ref.invalidate(contractsProvider),
          ),
          data: (contracts) {
            final rows = <({Appointment appointment, Contract contract})>[];
            for (final c in contracts) {
              for (final a in c.appointments) {
                rows.add((appointment: a, contract: c));
              }
            }
            final upcoming = rows.where((r) => !r.appointment.isPast).toList()
              ..sort((a, b) => a.appointment.dateTime.compareTo(b.appointment.dateTime));
            final past = rows.where((r) => r.appointment.isPast).toList()
              ..sort((a, b) => b.appointment.dateTime.compareTo(a.appointment.dateTime));

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Τα συμβόλαιά μου', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (contracts.isEmpty) const Text('Δεν υπάρχουν συμβόλαια.'),
                for (final contract in contracts) _ContractCard(contract: contract),
                const SizedBox(height: 24),
                Text('Επόμενα ραντεβού', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (upcoming.isEmpty) const Text('Δεν έχετε προσεχή ραντεβού.'),
                for (final row in upcoming)
                  _AppointmentTile(appointment: row.appointment, contract: row.contract),
                if (past.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _AppointmentHistorySection(rows: past),
                ],
                const SizedBox(height: 80),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openCreateAppointmentDialog(BuildContext context, WidgetRef ref, List<Contract> contracts) async {
    final bookable = contracts.where((c) => c.remainingSessions > 0).toList();
    if (bookable.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Δεν υπάρχουν διαθέσιμα ραντεβού σε κανένα συμβόλαιο.')),
      );
      return;
    }

    Contract selectedContract = bookable.first;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Νέο ραντεβού'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<Contract>(
                initialValue: selectedContract,
                decoration: const InputDecoration(labelText: 'Πακέτο'),
                items: [
                  for (final c in bookable)
                    DropdownMenuItem(value: c, child: Text(c.packageName, overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (value) => setState(() => selectedContract = value ?? selectedContract),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Ακύρωση')),
            FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Συνέχεια')),
          ],
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final dateTime = await _pickSlot(context, ref);
    if (dateTime == null || !context.mounted) return;

    final customerId = await ref.read(currentCustomerIdProvider.future);
    final failure = await ref.read(createAppointmentUseCaseProvider).call(
          customerId: customerId,
          contract: selectedContract,
          dateTime: dateTime,
        ).failureOrNull();
    if (!context.mounted) return;
    if (failure == null) ref.invalidate(contractsProvider);
    _showResult(context, failure, successMessage: 'Το ραντεβού δημιουργήθηκε.');
  }

  static Future<DateTime?> _pickSlot(BuildContext context, WidgetRef ref) async {
    final companyId = ref.read(profileControllerProvider).value?.companyId;
    if (companyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Περιμένετε να φορτώσει το προφίλ σας και δοκιμάστε ξανά.')),
      );
      return null;
    }
    final customerId = await ref.read(currentCustomerIdProvider.future);
    if (!context.mounted) return null;
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SlotPickerSheet(customerId: customerId, companyId: companyId),
    );
  }

  static void _showResult(BuildContext context, Failure? failure, {required String successMessage}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    if (failure == null) {
      messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    } else {
      messenger.showSnackBar(SnackBar(
        content: Text(failure.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }
}

class _ContractCard extends StatelessWidget {
  const _ContractCard({required this.contract});

  final Contract contract;

  Color? _parseColor(String? hex) {
    if (hex == null) return null;
    final cleaned = hex.replaceAll('#', '');
    final value = int.tryParse(cleaned.length == 6 ? 'FF$cleaned' : cleaned, radix: 16);
    return value == null ? null : Color(value);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final accent = _parseColor(contract.packageColor) ?? Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: ValueKey(contract.id),
        // Πολλοί πελάτες έχουν 15-20 συμβόλαια· τα ολοκληρωμένα δεν χρειάζονται
        // πλέον προσοχή, οπότε ξεκινούν μαζεμένα και δεν χτίζουν καν τα children
        // τους (progress bar) μέχρι να ανοιχτούν.
        initiallyExpanded: !contract.completed,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(contract.packageName, style: Theme.of(context).textTheme.titleMedium),
            ),
            if (contract.completed)
              const Chip(label: Text('Ολοκληρωμένο'), visualDensity: VisualDensity.compact)
            else if (!contract.isActive)
              Chip(
                label: const Text('Εξαντλήθηκε'),
                visualDensity: VisualDensity.compact,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Δημιουργήθηκε: ${dateFormat.format(contract.signUpDate)} • '
            '${contract.remainingSessions} / ${contract.totalSessions} συνεδρίες'
            '${contract.paid ? '' : ' • Εκκρεμεί πληρωμή'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: contract.usageRatio, minHeight: 8, color: accent),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Υπόλοιπο: ${contract.remainingSessions} / ${contract.totalSessions} συνεδρίες'),
          ),
        ],
      ),
    );
  }
}

class _AppointmentTile extends ConsumerWidget {
  const _AppointmentTile({required this.appointment, required this.contract});

  final Appointment appointment;
  final Contract contract;

  Color _statusColor(BuildContext context) {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return Theme.of(context).colorScheme.primary;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.overtime:
        return Colors.orange;
      case AppointmentStatus.canceled:
        return Theme.of(context).colorScheme.error;
    }
  }

  String _statusLabel() {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return 'Προγραμματισμένο';
      case AppointmentStatus.completed:
        return 'Ολοκληρώθηκε';
      case AppointmentStatus.overtime:
        return 'Εκπρόθεσμο';
      case AppointmentStatus.canceled:
        return 'Ακυρώθηκε';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('EEE dd/MM/yyyy • HH:mm', 'el_GR');
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _statusColor(context).withValues(alpha: 0.15),
          child: Icon(Icons.event_outlined, color: _statusColor(context)),
        ),
        title: Text(contract.packageName),
        subtitle: Text(
          '${_safeFormat(dateFormat, appointment.dateTime)}'
          '${appointment.trainerName != null ? '\nΠροπονητής: ${appointment.trainerName}' : ''}',
        ),
        isThreeLine: appointment.trainerName != null,
        trailing: appointment.canModify
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'reschedule') {
                    _reschedule(context, ref);
                  } else if (value == 'cancel') {
                    _cancel(context, ref);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'reschedule', child: Text('Αλλαγή ημερομηνίας')),
                  PopupMenuItem(value: 'cancel', child: Text('Ακύρωση')),
                ],
              )
            : appointment.canRestore
                ? TextButton(onPressed: () => _restore(context, ref), child: const Text('Επαναφορά'))
                : Chip(label: Text(_statusLabel()), visualDensity: VisualDensity.compact),
      ),
    );
  }

  String _safeFormat(DateFormat format, DateTime value) {
    try {
      return format.format(value);
    } catch (_) {
      return DateFormat('dd/MM/yyyy HH:mm').format(value);
    }
  }

  Future<void> _reschedule(BuildContext context, WidgetRef ref) async {
    final companyId = ref.read(profileControllerProvider).value?.companyId;
    if (companyId == null) return;
    final customerId = await ref.read(currentCustomerIdProvider.future);
    if (!context.mounted) return;
    final newDateTime = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SlotPickerSheet(customerId: customerId, companyId: companyId),
    );
    if (newDateTime == null || !context.mounted) return;
    final failure = await ref.read(rescheduleAppointmentUseCaseProvider).call(
          appointment: appointment,
          newDateTime: newDateTime,
        ).failureOrNull();
    if (!context.mounted) return;
    if (failure == null) ref.invalidate(contractsProvider);
    ContractsScreen._showResult(context, failure, successMessage: 'Το ραντεβού ενημερώθηκε.');
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ακύρωση ραντεβού'),
        content: const Text('Σίγουρα θέλετε να ακυρώσετε αυτό το ραντεβού;'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Όχι')),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Ναι, ακύρωση')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final failure = await ref.read(cancelAppointmentUseCaseProvider).call(appointment).failureOrNull();
    if (!context.mounted) return;
    if (failure == null) ref.invalidate(contractsProvider);
    ContractsScreen._showResult(context, failure, successMessage: 'Το ραντεβού ακυρώθηκε.');
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final failure = await ref.read(restoreAppointmentUseCaseProvider).call(appointment).failureOrNull();
    if (!context.mounted) return;
    if (failure == null) ref.invalidate(contractsProvider);
    ContractsScreen._showResult(context, failure, successMessage: 'Το ραντεβού επαναφέρθηκε.');
  }
}

/// Ένας πελάτης με πολλά συμβόλαια μπορεί να έχει εκατοντάδες περασμένα
/// ραντεβού· κρατάμε το ιστορικό μαζεμένο από προεπιλογή ώστε η οθόνη να
/// ανοίγει δείχνοντας μόνο ό,τι χρειάζεται δράση, και τα tiles του ιστορικού
/// να μη χτίζονται καν μέχρι ο χρήστης να τα ζητήσει ανοίγοντάς το.
class _AppointmentHistorySection extends StatelessWidget {
  const _AppointmentHistorySection({required this.rows});

  final List<({Appointment appointment, Contract contract})> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text('Ιστορικό ραντεβού (${rows.length})'),
        children: [
          for (final row in rows) _AppointmentTile(appointment: row.appointment, contract: row.contract),
        ],
      ),
    );
  }
}
