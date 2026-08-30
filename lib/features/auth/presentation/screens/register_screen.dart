import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/register_controller.dart';
import '../providers/register_state.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(registerControllerProvider.notifier).submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
    final isSubmitting = state.status == RegisterStatus.submitting;
    final isSubmitted = state.status == RegisterStatus.submitted;

    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (next.status == RegisterStatus.error && next.message != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.message!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Δημιουργία λογαριασμού')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: isSubmitted
                  ? _SubmittedView(message: state.message!, onBackToLogin: () => Navigator.of(context).pop())
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 24),
                          Icon(Icons.person_add_alt_1_outlined, size: 56, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 12),
                          Text(
                            'Δημιουργήστε τον λογαριασμό σας',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Χρησιμοποιήστε το email που έχετε δηλώσει στο γυμναστήριό σας. '
                            'Θα σας στείλουμε ένα email για να το επιβεβαιώσετε.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
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
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Υποχρεωτικό πεδίο';
                              if (value.length < 6) return 'Τουλάχιστον 6 χαρακτήρες';
                              final hasDigit = RegExp(r'\d').hasMatch(value);
                              final hasUpper = RegExp(r'[A-ZΑ-Ω]').hasMatch(value);
                              final hasLower = RegExp(r'[a-zα-ω]').hasMatch(value);
                              final hasSymbol = RegExp(r'[^A-Za-zΑ-Ωα-ω0-9]').hasMatch(value);
                              if (!hasDigit || !hasUpper || !hasLower || !hasSymbol) {
                                return 'Χρειάζεται κεφαλαίο, πεζό, αριθμό και σύμβολο';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Επιβεβαίωση κωδικού',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                              ),
                            ),
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            validator: (value) =>
                                (value != _passwordController.text) ? 'Οι κωδικοί δεν ταιριάζουν' : null,
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: isSubmitting ? null : _submit,
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Εγγραφή'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
                            child: const Text('Έχετε ήδη λογαριασμό; Σύνδεση'),
                          ),
                          const SizedBox(height: 16),
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

class _SubmittedView extends StatelessWidget {
  const _SubmittedView({required this.message, required this.onBackToLogin});

  final String message;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        Icon(Icons.mark_email_read_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onBackToLogin,
          child: const Text('Επιστροφή στη σύνδεση'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
