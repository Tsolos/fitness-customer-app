import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web_only;

/// The actual Google-rendered "Sign in with Google" button. This is the
/// *only* supported way to complete an interactive sign-in on Flutter Web:
/// `GoogleSignIn().signIn()` never resolves there (confirmed in testing —
/// the OAuth popup completes but the Dart Future hangs forever). Clicking
/// this button drives Google Identity Services directly and fires
/// `GoogleSignIn.onCurrentUserChanged`, which `LoginScreen` listens to.
Widget buildGoogleRenderButton() {
  return web_only.renderButton(
    configuration: web_only.GSIButtonConfiguration(
      theme: web_only.GSIButtonTheme.outline,
      size: web_only.GSIButtonSize.large,
      text: web_only.GSIButtonText.signinWith,
    ),
  );
}
