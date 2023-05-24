import 'package:adomob/theme/theme_constants.dart';
import 'package:adomob/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'm_init_mqtt_devices_app.dart';
import 'm_mobile_application.dart';

/// @nodoc
void main() {
  runApp(const ProviderScope(child: AppHomePage()));
}

ThemeManager themeManager = ThemeManager();

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
    themeManager.removeListener(themeListener);
    appMqttClientManager.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    themeManager.addListener(themeListener);
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
    return MaterialApp(
      title: 'INITIALISATION APPLICATION',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            appMqttClientManager.subscribe(subscribGatewayTopic);

            return PagePrincipale();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            "initialisation ...",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}
