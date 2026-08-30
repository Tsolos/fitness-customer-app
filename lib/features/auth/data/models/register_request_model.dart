/// Matches `AuthController.RegisterCustomer([FromBody] RegisterCustomerVM model)`
/// — no `confirmPassword` field, that check is purely client-side (the API
/// only ever sees the one password it needs to hash). Named `RegisterCustomerVM`
/// to avoid colliding with the existing `RegisterVM` (gym owner/staff sign-up).
class RegisterRequestModel {
  const RegisterRequestModel({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
