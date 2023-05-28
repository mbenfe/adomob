import 'package:adomob/m_build_from_json.dart';
import 'package:adomob/utils/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'm_define.dart';
import 'm_init_mqtt_devices_app.dart';
import 'm_mobile_application.dart';
import 'my_notifiers/bottom_navigation_bar_manager.dart';
import 'my_notifiers/theme_manager.dart';
import 'my_widgets/sub_widgets/top_widget.dart';

/// @nodoc
void main() {
  runApp(const ProviderScope(child: AppHomePage()));
}

//*****************************************************************************************/
//* root du programme Application mobile                                                  */
//* attend FUTUR que la liste des clients soit lue de puis MQTT/JSON data                 */
// **************************************************************************************
class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  final Future _initFuture = AppInit.initialize();

  @override
  void dispose() {
    appMqttClientManager.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    appInitialisation();
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          appMqttClientManager.subscribe(subscribGatewayTopic);

          return const PagePrincipale();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
    );
  }
}

/// ConsumerWidget for riverpod - ref for interaction with providers
class PagePrincipale extends ConsumerWidget {
  const PagePrincipale({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final currentIndex = ref.watch(bottomNavigationBarIndexProvider);
    final appIndex = currentIndex.bottomNavigationBarIndex;

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

    bool darkMode = ref.watch(themeModeProvider);
    int index = preDefinedBottomNavigationBar.indexWhere((element) => element.text == listApplications[appIndex]);
    int flexFactor = preDefinedBottomNavigationBar[index].flexFactor;
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Switch(
              value: darkMode,
              onChanged: (newValue) {
                ref.read(themeModeProvider.notifier).toggle();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Flexible(flex: flexFactor, child: TopWidget(selectedApplication: listApplications[appIndex])),
            Flexible(flex: 85, child: screens[appGetPageIndex(appIndex)]),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: appIndex,
            onTap: (value) => currentIndex.setBottomNavigationBarIndex(value),
            items: appGetListBottomNavigationBarItem()),
      ),
    );
  }
}
