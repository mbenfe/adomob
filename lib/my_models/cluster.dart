import 'package:json_annotation/json_annotation.dart';

import 'module.dart';

part 'cluster.g.dart';

@JsonSerializable(explicitToJson: true)
class Cluster {
  final List<Module> listModulesBundled;
  int rank;
  int row;

  Cluster({required this.listModulesBundled, required this.rank, required this.row});

  factory Cluster.fromJson(Map<String, dynamic> json) => _$ClusterFromJson(json);

  // Map<String, dynamic> toJson() => _$BundleToJson(this);
  Map<String, dynamic> toJson() => _$ClusterToJson(this);

  void setColumnRow(int newRank, int newRow) {
    rank = newRank;
    row = newRow;
  }
}
// flutter packages pub run build_runner build --delete-conflicting-outputs