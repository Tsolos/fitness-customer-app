import 'dart:convert';

/// Minimal JWT payload reader — no signature verification (the server is
/// the source of truth for that). We only need to read claims embedded by
/// the API's `AuthController.GeneratePoliciesJwtToken`, notably `userId`
/// (which equals the customer's GUID for guest/customer accounts, see
/// `GuestsController.RegisterGuest`) and the standard `exp` claim.
class JwtDecoder {
  JwtDecoder._();

  static Map<String, dynamic>? payload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static String? claim(String token, String claimName) {
    return payload(token)?[claimName]?.toString();
  }

  static DateTime? expiresAt(String token) {
    final exp = payload(token)?['exp'];
    if (exp == null) return null;
    final seconds = int.tryParse(exp.toString());
    if (seconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true).toLocal();
  }
}
