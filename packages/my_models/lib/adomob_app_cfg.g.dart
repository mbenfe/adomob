// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adomob_app_cfg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListElementApp _$ListElementAppFromJson(Map<String, dynamic> json) =>
    ListElementApp(
      type: json['type'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListElementAppToJson(ListElementApp instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      location: json['location'] as String,
      column: json['column'] as int,
      row: json['row'] as int,
      master: json['master'] as String,
      slave: (json['slave'] as List<dynamic>).map((e) => e as String).toList(),
      color: json['color'] as int,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'location': instance.location,
      'column': instance.column,
      'row': instance.row,
      'master': instance.master,
      'slave': instance.slave,
      'color': instance.color,
    };
