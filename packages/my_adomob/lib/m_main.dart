import 'package:flutter/material.dart';
import 'package:my_widgets/meteo/open_weather_map.dart';
import 'package:weather/weather.dart';

import 'm_initialisation.dart';
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
    app_initialisation();
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
    return InitializationApp();
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

/*****************************************************************************************/
/* root du programme Application mobile                                                  */
/* attend FUTUR que la liste des clients soit lue de puis MQTT/JSON data                 */
/// **************************************************************************************
class InitializationApp extends StatelessWidget {
  InitializationApp({super.key});
  final Future _initFuture = AppInit.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INITIALISATION APPLICATION',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            appMqttClientManager.subscribe(subscribGatewayTopic);

            return const AppWidgetLayout();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
