// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      city: json['city'] as String,
      customerId: json['customerId'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      postalCode: json['postalCode'] as String,
      street: json['street'] as String,
      surname: json['surname'] as String,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'city': instance.city,
      'customerId': instance.customerId,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'postalCode': instance.postalCode,
      'street': instance.street,
      'surname': instance.surname,
    };
