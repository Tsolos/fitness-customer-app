import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/widgets/brand_mark.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/gym.dart';
import '../providers/gym_providers.dart';

/// Bottom sheet used to pick which gym (company) the customer belongs to.
/// The same Google account's email can be a customer at more than one gym,
/// so this has to happen before a Google sign-in can be resolved to one
/// specific `Customer` row.
class GymPickerSheet extends ConsumerStatefulWidget {
  const GymPickerSheet({super.key});

  @override
  ConsumerState<GymPickerSheet> createState() => _GymPickerSheetState();
}

class _GymPickerSheetState extends ConsumerState<GymPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gymsAsync = ref.watch(gymsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Επιλέξτε το γυμναστήριό σας', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Αναζήτηση...',
              ),
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: gymsAsync.when(
                loading: () => const Padding(padding: EdgeInsets.all(24), child: LoadingIndicator()),
                error: (error, _) => ErrorView(
                  message: error is Failure ? error.message : 'Κάτι πήγε στραβά.',
                  onRetry: () => ref.invalidate(gymsProvider),
                ),
                data: (gyms) {
                  final filtered = _query.isEmpty
                      ? gyms
                      : gyms.where((g) => g.title.toLowerCase().contains(_query)).toList();
                  if (filtered.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Δεν βρέθηκαν γυμναστήρια.')),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final gym = filtered[index];
                      return ListTile(
                        leading: const BrandMark(size: 32),
                        title: Text(gym.title),
                        onTap: () => Navigator.of(context).pop<Gym>(gym),
                      );
                    },
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
