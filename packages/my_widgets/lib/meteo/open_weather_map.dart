import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:my_adomob/m_define.dart';

import 'meteo.dart';

enum DownloadState { notDownloaded, downloading, finishedDownloading }
//enum etatPrevisions { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

String myOpenWeatherMapKey = '5116bc8cbd4ceca5cc308087fb040df1';
late WeatherFactory webSocket;
late Weather donneesJour;
var donneesJourDecodees = {};

List<Weather> donneesPrevisions = [];
var donneesPrevisionsDecodees = [];
DownloadState etatJour = DownloadState.notDownloaded;
DownloadState etatPrevisions = DownloadState.notDownloaded;

class SubMeteo extends StatefulWidget {
  const SubMeteo({super.key});

  @override
  SubMeteoState createState() => SubMeteoState();
}

class SubMeteoState extends State<SubMeteo> {
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
    Weather jour = await webSocket.currentWeatherByCityName(ville);
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
    List<Weather> previsions = await webSocket.fiveDayForecastByCityName(ville);
    setState(() {
      donneesPrevisions = previsions;
      etatPrevisions = DownloadState.finishedDownloading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        affichageResultatsJour(),
        affichageResultatsPrevisions(),
      ],
    );
  }
}
