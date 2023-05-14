// Fetch content from the json file
import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

//-------------------------------- CUSTOMER --------------------------------
@JsonSerializable(explicitToJson: true)
class Customer {
  final String city;
  final int customerId;
  final String email;
  final String name;
  final String phone;
  final String postalCode;
  final String street;
  final String surname;

  const Customer({
    required this.city,
    required this.customerId,
    required this.email,
    required this.name,
    required this.phone,
    required this.postalCode,
    required this.street,
    required this.surname,
  });

  // flutter packages pub run build_runner build

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
// flutter packages pub run build_runner build --delete-conflicting-outputs
