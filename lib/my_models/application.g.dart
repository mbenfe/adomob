// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      listBundle: (json['listBundle'] as List<dynamic>)
          .map((e) => Cluster.fromJson(e as Map<String, dynamic>))
          .toList(),
      application: json['application'] as String,
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'application': instance.application,
      'listBundle': instance.listBundle.map((e) => e.toJson()).toList(),
    };
