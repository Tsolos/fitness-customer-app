import 'package:equatable/equatable.dart';

/// Mirrors `gym_api.Models.Sex` (`Male = 0, Female = 1`).
enum CustomerSex { male, female }

class Customer extends Equatable {
  const Customer({
    required this.id,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.address,
    this.area,
    this.city,
    this.postCode,
    this.birthDate,
    this.sex,
    this.photoUrl,
  });

  final String id;

  /// Not shown in the UI, but needed internally to call
  /// `getSlotAvailability` (its `branchID` is the customer's company).
  final String companyId;

  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? address;
  final String? area;
  final String? city;
  final String? postCode;
  final DateTime? birthDate;
  final CustomerSex? sex;

  /// A short-lived (24h) SAS URL, freshly generated server-side on every
  /// `getCustomerBasicInfo` call — always valid when received, never
  /// cached across app sessions.
  final String? photoUrl;

  String get fullName => '$firstName $lastName';

  Customer copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? area,
    String? city,
    String? postCode,
    String? photoUrl,
  }) {
    return Customer(
      id: id,
      companyId: companyId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      area: area ?? this.area,
      city: city ?? this.city,
      postCode: postCode ?? this.postCode,
      birthDate: birthDate,
      sex: sex,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props =>
      [id, companyId, firstName, lastName, email, phone, address, area, city, postCode, birthDate, sex, photoUrl];
}
