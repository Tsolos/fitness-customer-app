import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/customer.dart';

/// `GuestsController.updateCustomerBasicInfo` does `_context.Customers
/// .Update(customer)` — a full-entity update that marks *every* scalar
/// property as modified. If we constructed the PUT body from scratch
/// using only the fields this app edits, every other column (remarks,
/// signature, uniform measurements, ...) would get overwritten with
/// null/default.
///
/// So [raw] keeps the exact JSON this app received from
/// `getCustomerBasicInfo`, and [buildUpdateJson] only overlays the
/// specific keys the Profile screen lets the customer change, stripping
/// the nested navigation collections (contracts, payments, company, ...)
/// that shouldn't be round-tripped through a client PUT.
class CustomerModel {
  const CustomerModel({required this.raw, required this.customer});

  final Map<String, dynamic> raw;
  final Customer customer;

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(raw: json, customer: _toEntity(json));
  }

  static Customer _toEntity(Map<String, dynamic> json) {
    return Customer(
      id: parseString(json['customerID']),
      companyId: parseString(json['companyID']),
      firstName: parseString(json['givenName']),
      lastName: parseString(json['familyName']),
      email: parseString(json['email']),
      phone: parseNullableString(json['mobile']),
      address: parseNullableString(json['address']),
      area: parseNullableString(json['area']),
      city: parseNullableString(json['city']),
      postCode: parseNullableString(json['postCode']),
      birthDate: parseNullableDate(json['birthDate']),
      sex: parseInt(json['sex']) == 1 ? CustomerSex.female : CustomerSex.male,
      photoUrl: parseNullableString(json['photoUrl']),
    );
  }

  /// Navigation properties that must never be echoed back on a PUT — EF
  /// would try to track/insert/update whatever objects we send here.
  static const _navigationKeysToStrip = [
    'company',
    'source',
    'register',
    'whoCreated',
    'whoUpdated',
    'contracts',
    'demoAppointments',
    'history',
    'memberOfSMSGroups',
    'payments',
  ];

  Map<String, dynamic> buildUpdateJson(Customer edited) {
    final merged = Map<String, dynamic>.from(raw);
    for (final key in _navigationKeysToStrip) {
      merged.remove(key);
    }
    merged['givenName'] = edited.firstName;
    merged['familyName'] = edited.lastName;
    merged['email'] = edited.email;
    merged['mobile'] = edited.phone;
    merged['address'] = edited.address;
    merged['area'] = edited.area;
    merged['city'] = edited.city;
    merged['postCode'] = edited.postCode;
    return merged;
  }
}
