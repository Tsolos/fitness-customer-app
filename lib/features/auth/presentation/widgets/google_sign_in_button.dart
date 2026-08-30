import 'package:flutter/material.dart';

import 'google_render_button_stub.dart' if (dart.library.js_interop) 'google_render_button_web.dart';

/// Google's own rendered button — required on web (see doc comment in
/// `google_render_button_web.dart`).
///
/// Rendered exactly once and cached (`late final`): `renderButton()`
/// re-runs `google.accounts.id.initialize()` internally on every call, and
/// `LoginScreen` rebuilds often (several `ref.watch`s). Re-rendering on
/// every rebuild was silently re-registering the button's GIS callback
/// each time — "google.accounts.id.initialize() is called multiple
/// times... only the last initialized instance will be used" — which is
/// why a click sometimes never reached our listener.
class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  late final Widget _button = buildGoogleRenderButton();

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: _button);
  }
}
