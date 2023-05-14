import 'package:json_annotation/json_annotation.dart';

part 'adomob_app_cfg.g.dart';

/// class from json / to json
/// configuration des apps
/// exemple chauffage, thermostat, etc...cd

// flutter packages pub run build_runner build --delete-conflicting-outputs
// @JsonSerializable(explicitToJson: true)
// class ListApplications {
//   final List<ListElementApp> listApp;
//   ListApplications({required this.listApp});
//   factory ListApplications.fromJson(Map<String, dynamic> json) => _$ListApplicationsFromJson(json);

//   Map<String, dynamic> toJson() => _$ListApplicationsToJson(this);
// }

// flutter packages pub run build_runner build --delete-conflicting-outputs
@JsonSerializable(explicitToJson: true)
class ListElementApp {
  final String type;
  final List<Data> data;
  ListElementApp({required this.type, required this.data});
  factory ListElementApp.fromJson(Map<String, dynamic> json) => _$ListElementAppFromJson(json);

  Map<String, dynamic> toJson() => _$ListElementAppToJson(this);
}

//-------------------------------- CUSTOMER --------------------------------
@JsonSerializable(explicitToJson: true)
class Data {
  final String location;
  final int column;
  final int row;
  final String master;
  final List<String> slave;
  final int color;

  Data({
    required this.location,
    required this.column,
    required this.row,
    required this.master,
    required this.slave,
    required this.color,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
// flutter packages pub run build_runner build --delete-conflicting-outputs
