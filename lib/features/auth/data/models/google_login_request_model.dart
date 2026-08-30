/// Matches `AuthController.GoogleLoginVM`. Exactly one of [idToken] /
/// [accessToken] is normally set — see `GoogleTokens`'s doc comment for why
/// the app can end up with either one depending on platform.
class GoogleLoginRequestModel {
  const GoogleLoginRequestModel({required this.companyId, this.idToken, this.accessToken});

  final String companyId;
  final String? idToken;
  final String? accessToken;

  Map<String, dynamic> toJson() => {
        'companyID': companyId,
        'idToken': idToken,
        'accessToken': accessToken,
      };
}
