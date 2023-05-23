// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataCustomer _$DataCustomerFromJson(Map<String, dynamic> json) => DataCustomer(
      coordonnees:
          Customer.fromJson(json['coordonnees'] as Map<String, dynamic>),
      listApplication: (json['listApplication'] as List<dynamic>)
          .map((e) => Application.fromJson(e as Map<String, dynamic>))
          .toList(),
      listModules: (json['listModules'] as List<dynamic>)
          .map((e) => Module.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataCustomerToJson(DataCustomer instance) =>
    <String, dynamic>{
      'coordonnees': instance.coordonnees.toJson(),
      'listApplication':
          instance.listApplication.map((e) => e.toJson()).toList(),
      'listModules': instance.listModules.map((e) => e.toJson()).toList(),
    };
