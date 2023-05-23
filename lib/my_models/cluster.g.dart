// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cluster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cluster _$ClusterFromJson(Map<String, dynamic> json) => Cluster(
      listModulesBundled: (json['listModulesBundled'] as List<dynamic>)
          .map((e) => Module.fromJson(e as Map<String, dynamic>))
          .toList(),
      rank: json['rank'] as int,
      row: json['row'] as int,
    );

Map<String, dynamic> _$ClusterToJson(Cluster instance) => <String, dynamic>{
      'listModulesBundled':
          instance.listModulesBundled.map((e) => e.toJson()).toList(),
      'rank': instance.rank,
      'row': instance.row,
    };
