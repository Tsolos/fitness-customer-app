import '../../../../core/utils/jwt_decoder.dart';
import '../../domain/entities/auth_tokens.dart';

/// `AuthController.Login` returns `Ok(new { token = ... })` on success —
/// just the JWT, nothing else. `customerId` and `expiresAt` are derived
/// client-side by decoding the token's `userId` / `exp` claims.
class AuthResponseModel {
  const AuthResponseModel({required this.accessToken});

  final String accessToken;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String?;
    if (token == null) {
      throw const FormatException('Auth response is missing the "token" field.');
    }
    return AuthResponseModel(accessToken: token);
  }

  AuthTokens toEntity() {
    final customerId = JwtDecoder.claim(accessToken, 'userId');
    if (customerId == null) {
      throw const FormatException('JWT is missing the "userId" claim.');
    }
    return AuthTokens(
      accessToken: accessToken,
      customerId: customerId,
      expiresAt: JwtDecoder.expiresAt(accessToken),
    );
  }
}
