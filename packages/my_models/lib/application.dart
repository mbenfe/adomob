import 'package:json_annotation/json_annotation.dart';
import 'package:my_models/cluster.dart';

part 'application.g.dart';

@JsonSerializable(explicitToJson: true)
class Application {
  String application;
  List<Cluster> listBundle;

  Application({required this.listBundle, required this.application});

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);

  // Map<String, dynamic> toJson() => _$BundleToJson(this);
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}

// flutter packages pub run build_runner build --delete-conflicting-outputs
