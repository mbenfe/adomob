import 'package:freezed_annotation/freezed_annotation.dart';

import 'application.dart';
import 'customer.dart';
import 'module.dart';

part 'data_customer.g.dart';

@JsonSerializable(explicitToJson: true)
class DataCustomer {
  DataCustomer({required this.coordonnees, required this.listApplication, required this.listModules});

  factory DataCustomer.fromJson(Map<String, DataCustomer> json) => _$DataCustomerFromJson(json);

  Customer coordonnees;
  List<Application> listApplication;
  List<Module> listModules;

  // Map<String, dynamic> toJson() => _$BundleToJson(this);
  Map<String, dynamic> toJson() => _$DataCustomerToJson(this);
}
// flutter packages pub run build_runner build --delete-conflicting-outputs
