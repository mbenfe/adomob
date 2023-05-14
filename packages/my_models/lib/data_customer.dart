import 'package:json_annotation/json_annotation.dart';
import 'package:my_models/application.dart';
import 'package:my_models/customer.dart';
import 'package:my_models/module.dart';

part 'data_customer.g.dart';

@JsonSerializable(explicitToJson: true)
class DataCustomer {
  Customer coordonnees;
  List<Application> listApplication;
  List<Module> listModules;

  DataCustomer({required this.coordonnees, required this.listApplication, required this.listModules});

  factory DataCustomer.fromJson(Map<String, DataCustomer> json) => _$DataCustomerFromJson(json);

  // Map<String, dynamic> toJson() => _$BundleToJson(this);
  Map<String, dynamic> toJson() => _$DataCustomerToJson(this);
}
// flutter packages pub run build_runner build --delete-conflicting-outputs
