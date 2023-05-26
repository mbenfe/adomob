import 'package:adomob/my_notifiers/settable_manager.dart';
import 'package:adomob/utils/helper_widgets.dart';
import 'package:adomob/utils/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'm_init_mqtt_devices_app.dart';
import 'm_mobile_application.dart';
import 'my_notifiers/bottom_navigation_bar_manager.dart';
import 'my_notifiers/theme_manager.dart';

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

    bool darkMode = ref.watch(darkModeProvider);

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            const OptionelReglage(),
            addHorizontalSpace(45),
            Switch(
              value: darkMode,
              onChanged: (newValue) {
                ref.read(darkModeProvider.notifier).toggle();
              },
            )
          ],
        ),
        body: screens[appGetPageIndex(appIndex)],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1),
            ),
          ),
          child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: appIndex,
              onTap: (value) => currentIndex.setBottomNavigationBarIndex(value),
              items: appGetListBottomNavigationBarItem()),
        ),
      ),
    );
  }
}

class OptionelReglage extends ConsumerWidget {
  const OptionelReglage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(pageReglableProvider);

    return notifier.status == true
        ? IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          )
        : Container();
  }
}
