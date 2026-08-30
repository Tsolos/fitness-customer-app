import 'package:flutter/widgets.dart';

/// Non-web platforms never call this (see [buildGoogleRenderButton] usage
/// in `google_sign_in_button.dart`, gated by `kIsWeb`) — it only exists so
/// the conditional import has something to resolve to.
Widget buildGoogleRenderButton() => const SizedBox.shrink();
