//----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_models/complex_state_fz.dart';
import 'package:my_widgets/arrosage/arrosage.dart';
import 'package:my_widgets/blinder/blinder.dart';
import 'package:my_widgets/contact/contact.dart';
import 'package:my_widgets/extender/extender.dart';
import 'package:my_widgets/home/home.dart';
import 'package:my_widgets/light/light.dart';
import 'package:my_widgets/power/power.dart';
import 'package:my_widgets/room/room.dart';
import 'package:my_widgets/state/state.dart';
import 'package:my_widgets/state_notifier.dart';
import 'package:my_widgets/switch/switch.dart';
import 'package:my_widgets/temperature/temperature.dart';
import 'package:my_widgets/thermostat/thermostat.dart';
import 'package:my_widgets/climatisation/climatisation.dart';
import 'package:my_widgets/setup/setup.dart';

import 'm_define.dart';
import 'm_build_from_json.dart';
import 'm_notifier.dart';

/// ConsumerWidget for riverpod - ref for interaction with providers
class AppWidgetLayout extends ConsumerWidget {
  const AppWidgetLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final currentIndex = ref.watch(appBarIndexProvider);
    final appIndex = currentIndex.appBarIndex;

    final screens = [
      appBuildSelectedView('Home'),
      appBuildSelectedView('Arrosage'),
      appBuildSelectedView('Blinder'),
      appBuildSelectedView('Contact'),
      appBuildSelectedView('Extender'),
      appBuildSelectedView('Light'),
      appBuildSelectedView('Chauffage'),
      appBuildSelectedView('State'),
      appBuildSelectedView('Switch'),
      appBuildSelectedView('Temperature'),
      appBuildSelectedView('Thermostat'),
      appBuildSelectedView('Consommation'),
      appBuildSelectedView('Climatisation'),
      appBuildSelectedView('Setup'),
    ];
    return Scaffold(
      body: screens[appGetPageIndex(appIndex)],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: appIndex,
          onTap: (value) => currentIndex.setAppBarIndex(value),
          items: appGetListBottomNavigationBarItem()),
    );
  }
}

/// ---------------------------------------------------------------------------
/// build ONE appplication widget list
///
//* *********************************************************************************
//*
//* FONCTION PRINCIPALE DE CONSTRUCTION DES WIDGETS
//*
//*
//*
//* @param selectedApplication: ex "Chauffage", "Temperature" page application a construire
//* check pour toutes les applications connues
//* retourn la Widget root construite si l'application existe, sinon Placeholder()
//* *********************************************************************************
Widget appBuildSelectedView(String selectedApplication) {
  Widget selectedAppRootWidget = const Placeholder();
  int nbColumn = 0, nbRow = 0;
  List<Widget> listAllSelectedAppWidgets = [];

  var myListBundles2 = listBundles.where((element) => element.type == selectedApplication).toList();
  if (myListBundles2.isNotEmpty) {
    nbColumn = nbRow = 0;
    for (int i = 0; i < myListBundles2.length; i++) {
      nbColumn = max(nbColumn, myListBundles2[i].column);
      nbRow = max(nbRow, myListBundles2[i].row);
    }

    Widget selectedWidget;
    for (int indexRow = 0; indexRow < nbRow; indexRow++) {
      List<Widget> listRowWidgets = [];
      var listRow2 = myListBundles2.where((element) => element.row == indexRow + 1).toList();
      // define devices associated with widjet and mqtt providers
      for (int indexColumn = 0; indexColumn < listRow2.length; indexColumn++) {
        //* trouve le bundle associé a l'application la ligne et la colonne
        Bundle bundle = Bundle();
        for (int i = 0; i < listBundles.length; i++) {
          if (listBundles[i].column == indexColumn + 1 && listBundles[i].row == indexRow + 1 && listBundles[i].type == selectedApplication) {
            bundle = listBundles[i];
            break;
          }
        }

        selectedWidget = GeneratedWidget(
          type: selectedApplication,
          listStateProviders: bundle.listStateProviders,
          location: bundle.location,
          master: bundle.master,
          listSlaves: bundle.listSlaves,
        );

        //* ajout sur la ligne
        listRowWidgets.add(selectedWidget);
      }
      listAllSelectedAppWidgets.add(appBuildRow(listRowWidgets));
    }
    selectedAppRootWidget = SafeArea(
      child: SizedBox(
        height: 1000,
        width: 500,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          primary: false,
          controller: ScrollController(keepScrollOffset: true),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < listAllSelectedAppWidgets.length; i++) listAllSelectedAppWidgets[i],
            ],
          ),
        ),
      ),
    );
  } else {
    //! taille a revoir pour etre adaptative
    //* thermostat n'a pas de device, c'est appli independante.
    return const Placeholder();
  }
  return selectedAppRootWidget; // construite ou placeholder()
}

// ---------------------------------------------------------------------------
/// ConsumerWidget for riverpod
class GeneratedWidget extends ConsumerWidget {
  const GeneratedWidget(
      {Key? key, required this.type, required this.master, required this.listSlaves, required this.listStateProviders, required this.location})
      : super(key: key);

  final String type;
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    switch (type.toUpperCase()) {
      case 'HOME':
        return RootHomeWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'ARROSAGE':
        return RootArrosageWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'BLINDER':
        return RootBlinderWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'CONTACT':
        return RootContactWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'LIGHT':
        return RootLightWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'EXTENDER':
        return RootExtenderWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'CHAUFFAGE':
        return RootRoomWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'STATE':
        return RootStateWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'SWITCH':
        return RootSwitchWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'TEMPERATURE':
        return RootTemperatureWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'THERMOSTAT':
        return RootThermostatWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'CONSOMMATION':
        if (listSlaves.isEmpty) {
          return RootConsomationWidgetMaitre(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
        } else {
          return RootConsomationWidgetVirtuel(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
        }
      case 'CLIMATISATION':
        return RootClimatisationWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      case 'SETUP':
        return RootSetupWidget(master: master, listSlaves: listSlaves, listStateProviders: listStateProviders, location: location);
      default:
        return const Placeholder();
    }
  }
}

// ---------------------------------------------------------------------------
Widget appBuildRow(List<Widget> list) {
  int i;
  Widget widget = SingleChildScrollView(
    primary: false,
    controller: ScrollController(
      keepScrollOffset: true,
    ),
    physics: const ScrollPhysics(),
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (i = 0; i < list.length; i++) list[i],
      ],
    ),
  );
  return widget;
}

// -----------------------------------------------------------------
int appGetPageIndex(int appIndex) {
  int index;
  List<BottomNavigationBarItem> listAllApps = [];

  listAllApps = appGetListBottomNavigationBarItem();
  String appName = listAllApps[appIndex].label.toString();
  index = preDefinedAppBar.indexWhere((element) => element.text == appName);
  return index;
}

//-------------------------------------------------- build list bottom app bar
List<BottomNavigationBarItem> appGetListBottomNavigationBarItem() {
  int i;
  List<BottomNavigationBarItem> list = [];
  for (i = 0; i < listApplications.length; i++) {
    var bundle = preDefinedAppBar.firstWhere((element) => element.text == listApplications[i]);
    list.add(BottomNavigationBarItem(icon: Icon(bundle.icon), label: bundle.text));
  }
  if (list.length < 2) {
    list.add(const BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''));
  }
  return list;
}
