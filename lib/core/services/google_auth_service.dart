import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_config.dart';
import '../error/exceptions.dart';

/// Whichever of the two Google gives us — the two sign-in paths this app
/// uses hand back different token types:
/// - Web ([GoogleSignInButton] / [GoogleAuthService.onAccountChanged]):
///   an OIDC **ID token** (`idToken`), no access token.
/// - Mobile/desktop ([GoogleAuthService.signIn]): an OAuth **access
///   token** (`accessToken`), reliably; the ID token is not guaranteed.
///
/// `AuthController.GoogleLogin` accepts either and verifies whichever was
/// sent.
typedef GoogleTokens = ({String? idToken, String? accessToken});

/// Thin wrapper around `google_sign_in`.
class GoogleAuthService {
  GoogleAuthService({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const ['email'],
              // Web: this IS the client id used for the sign-in flow itself.
              clientId: kIsWeb ? AppConfig.googleWebClientId : AppConfig.googleIosClientId,
              serverClientId: kIsWeb ? null : AppConfig.googleWebClientId,
            );

  final GoogleSignIn _googleSignIn;

  /// Fires whenever the signed-in Google account changes — including right
  /// after the user completes sign-in through the rendered web button
  /// (`GoogleSignInButton`). This is the *only* reliable way to observe a
  /// completed web sign-in; see the doc comment on `buildGoogleRenderButton`.
  Stream<GoogleSignInAccount?> get onAccountChanged => _googleSignIn.onCurrentUserChanged;

  Future<GoogleTokens> tokensFor(GoogleSignInAccount account) async {
    final auth = await account.authentication;
    return (idToken: auth.idToken, accessToken: auth.accessToken);
  }

  /// Mobile/desktop only — imperatively opens the account picker and
  /// returns its tokens, or null if the user cancelled. Never resolves on
  /// web; use [GoogleSignInButton] + [onAccountChanged] there.
  Future<GoogleTokens?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final tokens = await tokensFor(account);
      if (tokens.idToken == null && tokens.accessToken == null) {
        throw const ServerException(message: 'Το Google δεν επέστρεψε έγκυρο token.');
      }
      return tokens;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Η σύνδεση με Google απέτυχε: $e');
    }
  }

  /// Clears the cached Google session so the account picker shows again
  /// next time (called on app logout).
  Future<void> signOut() => _googleSignIn.signOut();
}
