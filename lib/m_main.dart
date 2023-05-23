import 'package:adomob/theme/theme_constants.dart';
import 'package:adomob/theme/theme_manager.dart';
import 'package:flutter/material.dart';

import 'm_init_mqtt_devices_app.dart';
import 'm_mobile_application.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key}) : super(key: key);

// 2023 a revoir
  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    appInitialisation();
  }

  @override
  void dispose() {
    appMqttClientManager.disconnect();
    super.dispose();
  }

  // TODO voir la necessite de ref//  }

  @override
  Widget build(BuildContext context) {
    //  WidgetsBinding.instance.addPostFrameCallback((_) => initialisation(ref));
    // var reference = ref.watch;
    return const InitializationApp();
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

ThemeManager themeManager = ThemeManager();

//*****************************************************************************************/
//* root du programme Application mobile                                                  */
//* attend FUTUR que la liste des clients soit lue de puis MQTT/JSON data                 */
// **************************************************************************************
class InitializationApp extends StatefulWidget {
  const InitializationApp({super.key});

  @override
  State<InitializationApp> createState() => _InitializationAppState();
}

class _InitializationAppState extends State<InitializationApp> {
  final Future _initFuture = AppInit.initialize();

  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    themeManager.addListener(themeListener);
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
