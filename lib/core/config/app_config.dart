/// Central place for environment-dependent configuration.
///
/// Override at build/run time with:
///   flutter run --dart-define=API_BASE_URL=https://10.0.2.2:44317
///   flutter build web --dart-define=API_BASE_URL=https://api.mygym.com
///
/// Note the base URL has NO trailing `/api` — [ApiEndpoints] paths already
/// include it (they mirror the ASP.NET Core route attributes 1:1).
class AppConfig {
  AppConfig._();

  /// Default points at the local ASP.NET Core dev server.
  /// - Chrome / Windows desktop (same machine as the API): `localhost` works as-is.
  /// - Android **emulator**: use `10.0.2.2` instead of `localhost` (the emulator's
  ///   alias for the host machine) — pass via `--dart-define=API_BASE_URL=...`.
  /// - Physical device / iOS simulator on the same network: use the host
  ///   machine's LAN IP instead.
  static const String _defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://localhost:44317',
  );

  static String get apiBaseUrl => _defaultBaseUrl;

  static const bool enableHttpLogging = bool.fromEnvironment(
    'ENABLE_HTTP_LOGGING',
    defaultValue: true,
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// The **Web** OAuth 2.0 Client ID from Google Cloud Console.
  ///
  /// Used as `serverClientId` so `GoogleAuthService.signIn()` returns an ID
  /// token whose `aud` claim is this Web client id on every platform
  /// (Android/iOS/Web) — matching what `AuthController.GoogleLogin` checks
  /// via `GoogleAuth:WebClientId` in appsettings.json. Empty until you
  /// create the OAuth clients (see README / setup notes); Google Sign-In
  /// fails gracefully with an error message until then.
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '677564013901-k0n4dh5r9969e5rnb8ht6c4lv9vfska2.apps.googleusercontent.com',
  );

  /// The **iOS** OAuth 2.0 Client ID — only needed for the iOS build; also
  /// requires the matching reversed-client-id URL scheme in
  /// ios/Runner/Info.plist (see setup notes).
  static const String googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
}
