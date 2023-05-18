import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

import 'open_weather_map.dart';

class SubMeteoWidget extends StatefulWidget {
  const SubMeteoWidget({super.key});

  @override
  State<SubMeteoWidget> createState() => SubMeteoWidgetState();
}

class SubMeteoWidgetState extends State<SubMeteoWidget> {
  @override
  initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    webSocket = WeatherFactory(myOpenWeatherMapKey, language: Language.FRENCH);
    // demande jour
    Future.delayed(Duration.zero, () {
      demandeJour();
    });
    // demande previsions
    Future.delayed(Duration.zero, () {
      demandePrevisions();
    });
  }

  void demandeJour() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      etatJour = DownloadState.downloading;
    });
    Weather jour = await webSocket.currentWeatherByCityName('seignosse');
    setState(() {
      donneesJour = jour;
      etatJour = DownloadState.finishedDownloading;
    });
  }

  void demandePrevisions() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      etatPrevisions = DownloadState.downloading;
    });
    List<Weather> previsions = await webSocket.fiveDayForecastByCityName('seignosse');
    setState(() {
      donneesPrevisions = previsions;
      etatPrevisions = DownloadState.finishedDownloading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        SubMeteo(),
      ],
    );
  }
}

class JourWidget extends StatefulWidget {
  const JourWidget({super.key});

  @override
  State<JourWidget> createState() => JourWidgetState();
}

class JourWidgetState extends State<JourWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(textDirection: TextDirection.ltr, donneesJour.temperature.toString())],
      ),
    );
  }
}

class PrevisionsWidget extends StatefulWidget {
  const PrevisionsWidget({super.key});

  @override
  State<PrevisionsWidget> createState() => _PrevisionsWidgetState();
}

class _PrevisionsWidgetState extends State<PrevisionsWidget> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          for (i = 0; i < donneesPrevisions.length; i += 8)
            SizedBox(
              height: MediaQuery.of(context).size.width / 5,
              width: MediaQuery.of(context).size.width / 5,
              child: const Placeholder(),
            ),
        ],
      ),
    );
  }
}

Widget contentDownloading() {
  return Container(
    margin: const EdgeInsets.only(top: 50),
    child: const Center(
      child: CircularProgressIndicator(strokeWidth: 10),
    ),
  );
}

Widget affichageResultatsJour() {
  if (etatJour == DownloadState.finishedDownloading) {
    return const JourWidget();
  } else {
    return contentDownloading();
  }
}

Widget affichageResultatsPrevisions() {
  if (etatPrevisions == DownloadState.finishedDownloading) {
    return const PrevisionsWidget();
  } else {
    return contentDownloading();
  }
}
