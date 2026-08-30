import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../../gym/domain/entities/gym.dart';
import '../../../gym/presentation/providers/gym_providers.dart';
import '../../../gym/presentation/widgets/gym_picker_sheet.dart';
import '../providers/auth_controller.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';
import '../widgets/google_sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _prefilled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );
  }

  Future<void> _submitWithBiometrics() async {
    await ref.read(authControllerProvider.notifier).loginWithBiometrics();
  }

  /// The same Google account's email can belong to a customer at more
  /// than one gym, so a gym must be picked before we know which
  /// `Customer` row to match against.
  Future<Gym?> _ensureGymSelected() async {
    final current = ref.read(selectedGymProvider).value;
    if (current != null) return current;

    final picked = await showModalBottomSheet<Gym>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const GymPickerSheet(),
    );
    if (picked == null) return null;
    await ref.read(selectedGymProvider.notifier).select(picked);
    return picked;
  }

  Future<void> _submitWithGoogle() async {
    final gym = await _ensureGymSelected();
    if (gym == null || !mounted) return;
    await ref.read(authControllerProvider.notifier).loginWithGoogle(gymId: gym.id);
  }

  Future<void> _changeGym() async {
    final picked = await showModalBottomSheet<Gym>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const GymPickerSheet(),
    );
    if (picked != null) {
      await ref.read(selectedGymProvider.notifier).select(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rememberedAsync = ref.watch(rememberedCredentialsProvider);
    rememberedAsync.whenData((remembered) {
      if (remembered != null && !_prefilled) {
        _prefilled = true;
        _emailController.text = remembered.email;
        _passwordController.text = remembered.password;
        _rememberMe = true;
      }
    });

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated && next.errorMessage != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    // Web: GoogleSignInButton can't be gated by our own onPressed handler
    // (it's Google's own rendered button), so completion is event-driven —
    // react here once it hands back a token.
    ref.listen<AsyncValue<GoogleTokens?>>(googleWebTokensProvider, (previous, next) {
      if (!kIsWeb) return;
      final tokens = next.value;
      if (tokens == null || (tokens.idToken == null && tokens.accessToken == null)) return;
      final gymId = ref.read(selectedGymProvider).value?.id;
      if (gymId == null) return;
      ref.read(authControllerProvider.notifier).completeGoogleLogin(
            gymId: gymId,
            idToken: tokens.idToken,
            accessToken: tokens.accessToken,
          );
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.unknown;
    final canUseBiometricAsync = ref.watch(canUseBiometricLoginProvider);
    final selectedGym = ref.watch(selectedGymProvider).value;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),
                    Icon(Icons.fitness_center, size: 64, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Καλωσήρθατε',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Συνδεθείτε για να δείτε τα στοιχεία σας',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: isLoading ? null : _changeGym,
                        icon: const Icon(Icons.storefront_outlined, size: 18),
                        label: Text(selectedGym?.title ?? 'Επιλέξτε γυμναστήριο'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          (value == null || !value.contains('@')) ? 'Μη έγκυρο email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Κωδικός πρόσβασης',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Υποχρεωτικό πεδίο' : null,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value ?? false),
                        ),
                        const Text('Απομνημόνευση στοιχείων'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Σύνδεση'),
                    ),
                    canUseBiometricAsync.maybeWhen(
                      data: (canUse) => canUse
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: OutlinedButton.icon(
                                onPressed: isLoading ? null : _submitWithBiometrics,
                                icon: const Icon(Icons.fingerprint),
                                label: const Text('Σύνδεση με δακτυλικό αποτύπωμα'),
                              ),
                            )
                          : const SizedBox.shrink(),
                      orElse: () => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('ή', style: Theme.of(context).textTheme.bodySmall),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (kIsWeb && selectedGym != null)
                      // Google's own rendered button — required on web,
                      // see GoogleAuthService's doc comment for why.
                      const GoogleSignInButton()
                    else
                      OutlinedButton.icon(
                        onPressed: isLoading ? null : (kIsWeb ? _changeGym : _submitWithGoogle),
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: Text(kIsWeb ? 'Επιλέξτε γυμναστήριο για Google' : 'Σύνδεση με Google'),
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: isLoading ? null : () => context.push(RoutePaths.register),
                      child: const Text('Δεν έχετε λογαριασμό; Εγγραφή'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
