// Fetch content from the json file
import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

//-------------------------------- MODULE FULL --------------------------------
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Module {
  static toNull(_) => null;

  @JsonKey(toJson: toNull, includeIfNull: false)
  String comment = "";
  @JsonKey(toJson: toNull, includeIfNull: false)
  int customerId = 0;

  String function = "";

  @JsonKey(toJson: toNull, includeIfNull: false)
  int id = 0;
  @JsonKey(toJson: toNull, includeIfNull: false)
  String linkage = "";
  @JsonKey(toJson: toNull, includeIfNull: false)
  String command = "";

  String location = "";

  @JsonKey(toJson: toNull, includeIfNull: false)
  String marque = "";
  @JsonKey(toJson: toNull, includeIfNull: false)
  String mqtt = "";

  String profile = "";

  @JsonKey(toJson: toNull, includeIfNull: false)
  String technology = "";

  String uniqueId = "";

  @JsonKey(toJson: toNull, includeIfNull: false)
  String purpose = "";
  @JsonKey(toJson: toNull, includeIfNull: false)
  int bundle = 0;
  @JsonKey(toJson: toNull, includeIfNull: false)
  bool? isBundled; // not part of json/sql used later for lqyoutflutter

  Module({
    required this.comment,
    required this.customerId,
    required this.function,
    required this.id,
    required this.linkage,
    required this.command,
    required this.location,
    required this.marque,
    required this.mqtt,
    required this.profile,
    required this.technology,
    required this.uniqueId,
    required this.purpose,
    required this.bundle,
    this.isBundled = false,
  });

  // flutter packages pub run build_runner build --delete-conflicting-outputs

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleToJson(this);
}
