import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/customer.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isSaving = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _areaController;
  late final TextEditingController _cityController;
  late final TextEditingController _postCodeController;

  bool _controllersInitialized = false;

  void _initControllersFrom(Customer customer) {
    if (_controllersInitialized) return;
    _firstNameController = TextEditingController(text: customer.firstName);
    _lastNameController = TextEditingController(text: customer.lastName);
    _emailController = TextEditingController(text: customer.email);
    _phoneController = TextEditingController(text: customer.phone ?? '');
    _addressController = TextEditingController(text: customer.address ?? '');
    _areaController = TextEditingController(text: customer.area ?? '');
    _cityController = TextEditingController(text: customer.city ?? '');
    _postCodeController = TextEditingController(text: customer.postCode ?? '');
    _controllersInitialized = true;
  }

  @override
  void dispose() {
    if (_controllersInitialized) {
      _firstNameController.dispose();
      _lastNameController.dispose();
      _emailController.dispose();
      _phoneController.dispose();
      _addressController.dispose();
      _areaController.dispose();
      _cityController.dispose();
      _postCodeController.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 1000);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    await _uploadPhoto(bytes, picked.name);
  }

  Future<void> _uploadPhoto(Uint8List bytes, String fileName) async {
    final ok = await ref.read(profileControllerProvider.notifier).uploadPhoto(bytes: bytes, fileName: fileName);
    if (!mounted) return;
    if (ok) {
      _showSnack('Η φωτογραφία ενημερώθηκε.');
    } else {
      _showError('Η μεταφόρτωση της φωτογραφίας απέτυχε.');
    }
  }

  Future<void> _save(Customer original) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final updated = original.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      area: _areaController.text.trim(),
      city: _cityController.text.trim(),
      postCode: _postCodeController.text.trim(),
    );
    final ok = await ref.read(profileControllerProvider.notifier).updateProfile(updated);
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      if (ok) _isEditing = false;
    });
    if (ok) {
      _showSnack('Τα στοιχεία ενημερώθηκαν.');
    } else {
      _showError('Η ενημέρωση απέτυχε. Δοκιμάστε ξανά.');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: Theme.of(context).colorScheme.error));
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Το προφίλ μου'),
        actions: [
          profileAsync.maybeWhen(
            data: (customer) => IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined),
              tooltip: _isEditing ? 'Ακύρωση' : 'Επεξεργασία',
              onPressed: () => setState(() {
                if (_isEditing) _initControllersFrom(customer);
                _isEditing = !_isEditing;
              }),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: error is Failure ? error.message : 'Κάτι πήγε στραβά.',
          onRetry: () => ref.invalidate(profileControllerProvider),
        ),
        data: (customer) {
          _initControllersFrom(customer);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 56,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: ClipOval(
                              child: customer.photoUrl == null
                                  ? Text(
                                      customer.firstName.isNotEmpty ? customer.firstName[0] : '?',
                                      style: const TextStyle(fontSize: 32),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: customer.photoUrl!,
                                      width: 112,
                                      height: 112,
                                      fit: BoxFit.cover,
                                      placeholder: (_, _) => const CircularProgressIndicator(strokeWidth: 2),
                                      errorWidget: (_, _, _) => Text(
                                        customer.firstName.isNotEmpty ? customer.firstName[0] : '?',
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: _pickPhoto,
                              borderRadius: BorderRadius.circular(20),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: const Icon(Icons.camera_alt_outlined, size: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _isEditing ? _buildEditForm(customer) : _buildReadOnlyView(customer),
                      const SizedBox(height: 32),
                      _buildSettingsSection(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReadOnlyView(Customer customer) {
    final addressParts = [customer.address, customer.postCode, customer.city, customer.area]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(', ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(icon: Icons.badge_outlined, label: 'Ονοματεπώνυμο', value: customer.fullName),
            _InfoRow(icon: Icons.email_outlined, label: 'Email', value: customer.email),
            _InfoRow(icon: Icons.phone_outlined, label: 'Τηλέφωνο', value: customer.phone ?? '—'),
            _InfoRow(icon: Icons.home_outlined, label: 'Διεύθυνση', value: addressParts.isEmpty ? '—' : addressParts),
            if (customer.birthDate != null)
              _InfoRow(
                icon: Icons.cake_outlined,
                label: 'Ημ. γέννησης',
                value: DateFormat('dd/MM/yyyy').format(customer.birthDate!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(Customer customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: 'Όνομα'),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Υποχρεωτικό πεδίο' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _lastNameController,
          decoration: const InputDecoration(labelText: 'Επώνυμο'),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Υποχρεωτικό πεδίο' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => (v == null || !v.contains('@')) ? 'Μη έγκυρο email' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Τηλέφωνο'),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Διεύθυνση'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _postCodeController,
                decoration: const InputDecoration(labelText: 'Τ.Κ.'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Πόλη'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _areaController,
          decoration: const InputDecoration(labelText: 'Περιοχή'),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _isSaving ? null : () => _save(customer),
          child: _isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Αποθήκευση'),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    final biometricSupportedAsync = ref.watch(biometricDeviceSupportedProvider);
    final biometricEnabledAsync = ref.watch(biometricEnabledProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: biometricSupportedAsync.maybeWhen(
            data: (supported) => supported
                ? biometricEnabledAsync.maybeWhen(
                    data: (enabled) => SwitchListTile(
                      secondary: const Icon(Icons.fingerprint),
                      title: const Text('Σύνδεση με δακτυλικό αποτύπωμα'),
                      value: enabled,
                      onChanged: (value) async {
                        final result = await ref.read(toggleBiometricUseCaseProvider).call(value);
                        ref.invalidate(biometricEnabledProvider);
                        result.fold(
                          (failure) => _showError(failure.message),
                          (_) => null,
                        );
                      },
                    ),
                    orElse: () => const ListTile(title: Text('Φόρτωση ρυθμίσεων...')),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Αποσύνδεση'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
