import 'package:equatable/equatable.dart';

class AuthTokens extends Equatable {
  const AuthTokens({
    required this.accessToken,
    required this.customerId,
    this.expiresAt,
  });

  final String accessToken;

  /// `AuthController.GeneratePoliciesJwtToken` embeds this as the `userId`
  /// claim. For guest/customer accounts it equals `Customer.CustomerID`
  /// (see `GuestsController.RegisterGuest`), so we use it directly to call
  /// every `customerID`-scoped Guests endpoint without a separate lookup.
  final String customerId;
  final DateTime? expiresAt;

  @override
  List<Object?> get props => [accessToken, customerId, expiresAt];
}
