/// Central catalogue of API routes — mirrors `AuthController` /
/// `GuestsController` / `CustomersController` in the gym_api backend.
class ApiEndpoints {
  ApiEndpoints._();

  // --- Auth ---
  static const String login = '/api/Auth/login';
  static const String googleLogin = '/api/Auth/googleLogin';

  /// New endpoint — see `AuthController.RegisterCustomer` (TODO: add this
  /// action, it doesn't exist in the shared controller source yet). Named
  /// `registerCustomer`, not `register` — `AuthController.Register` /
  /// `RegisterVM` already exist for a completely different flow (gym
  /// owner/staff sign-up). Not gym-scoped: the backend matches the email
  /// against `Customer` rows across every company. Always returns a
  /// generic "check your email" message, whether or not a match was
  /// found, to avoid leaking customer existence.
  static const String register = '/api/Auth/registerCustomer';

  /// New endpoint — see `AuthController.GetGyms` (TODO: add this action,
  /// it doesn't exist in the shared controller source yet).
  static const String gyms = '/api/Auth/gyms';

  // --- Guests (customer self-service) ---
  static String customerBasicInfo(String customerId) => '/api/Guests/getCustomerBasicInfo/$customerId';
  static const String updateCustomerBasicInfo = '/api/Guests/updateCustomerBasicInfo';

  /// Lives on the admin `CustomersController`, not `Guests`. Response is
  /// `{ "url": "<full Azure Blob URL>" }`; the URL is also persisted on
  /// `Customer.PhotoUrl` and comes back as `photoUrl` from
  /// `getCustomerBasicInfo` from then on — no separate "get avatar" call.
  static const String uploadCustomerPhoto = '/api/Customers/uploadAvatar';

  static String guestContracts(String customerId) => '/api/Guests/getGuestContracts/$customerId';

  static String addAppointment(String customerId) => '/api/Guests/addAppointment/$customerId';
  static String changeAppointmentDate(String appointmentId, String newSlotIso) =>
      '/api/Guests/changeAppointmentDate/$appointmentId/${Uri.encodeComponent(newSlotIso)}';
  static String cancelAppointment(String appointmentId) => '/api/Guests/cancelAppointment/$appointmentId';
  static String restoreAppointment(String appointmentId) => '/api/Guests/restoreAppointment/$appointmentId';
  static const String slotAvailability = '/api/Guests/getSlotAvailability';

  static String allMeasurements(String customerId) => '/api/Guests/getAllMeasurements/$customerId';
  static String measurement(String appointmentId) => '/api/Guests/getMeasurement/$appointmentId';

  static const String registerGuest = '/api/Guests/registerGuest';
  static String guestLoginData(String customerId) => '/api/Guests/getGuestLoginData/$customerId';
}
