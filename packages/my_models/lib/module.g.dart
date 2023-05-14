// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Module _$ModuleFromJson(Map<String, dynamic> json) => Module(
      comment: json['comment'] as String,
      customerId: json['customerId'] as int,
      function: json['function'] as String,
      id: json['id'] as int,
      linkage: json['linkage'] as String,
      command: json['command'] as String,
      location: json['location'] as String,
      marque: json['marque'] as String,
      mqtt: json['mqtt'] as String,
      profile: json['profile'] as String,
      technology: json['technology'] as String,
      uniqueId: json['uniqueId'] as String,
      purpose: json['purpose'] as String,
      bundle: json['bundle'] as int,
      isBundled: json['isBundled'] as bool? ?? false,
    );

Map<String, dynamic> _$ModuleToJson(Module instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('comment', Module.toNull(instance.comment));
  writeNotNull('customerId', Module.toNull(instance.customerId));
  val['function'] = instance.function;
  writeNotNull('id', Module.toNull(instance.id));
  writeNotNull('linkage', Module.toNull(instance.linkage));
  writeNotNull('command', Module.toNull(instance.command));
  val['location'] = instance.location;
  writeNotNull('marque', Module.toNull(instance.marque));
  writeNotNull('mqtt', Module.toNull(instance.mqtt));
  val['profile'] = instance.profile;
  writeNotNull('technology', Module.toNull(instance.technology));
  val['uniqueId'] = instance.uniqueId;
  writeNotNull('purpose', Module.toNull(instance.purpose));
  writeNotNull('bundle', Module.toNull(instance.bundle));
  writeNotNull('isBundled', Module.toNull(instance.isBundled));
  return val;
}
