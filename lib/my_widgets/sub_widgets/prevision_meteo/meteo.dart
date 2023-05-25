import 'dart:math';

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../../m_define.dart';
import '../../../utils/helper_widgets.dart';
import 'icons.dart';
import 'open_weather_map.dart';

List<String> jourSemaine = ['', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
List<String> mois = [
  'Jan',
  'Fev',
  'Mar',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
];

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
    return const OpenWeatherMapCall();
  }
}

class RowJourWidget extends StatefulWidget {
  const RowJourWidget({super.key});

  @override
  State<RowJourWidget> createState() => RowJourWidgetState();
}

class RowJourWidgetState extends State<RowJourWidget> {
  String code = donneesJour.weatherConditionCode.toString();
  BoxedIcon icon = tabIcons['802']['icon'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, //! a reajuster
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          WidgetDayLong(),
          WidgetDayGraphe(),
        ],
      ),
    );
  }
}

class RowPrevisionsWidget extends StatefulWidget {
  const RowPrevisionsWidget({super.key});

  @override
  State<RowPrevisionsWidget> createState() => _RowPrevisionsWidgetState();
}

class _RowPrevisionsWidgetState extends State<RowPrevisionsWidget> {
  int i = 0;
  String code = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (i = 8; i < donneesPrevisions.length; i += 8)
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 5,
            child: Card(elevation: 5, child: WidgetDayShort(index: i)),
          ),
      ],
    );
  }
}

class WidgetDayShort extends StatelessWidget {
  const WidgetDayShort({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    int i;
    double tempMin = 100;
    double tempMax = 0;
    for (i = 0; i < 8; i++) {
      tempMin = min(tempMin, donneesPrevisions[index + i].tempMin?.celsius ?? 0);
      tempMax = max(tempMax, donneesPrevisions[index + i].tempMax?.celsius ?? 0);
    }
    String jour = jourSemaine[donneesPrevisions[index].date?.weekday ?? 0];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(jour),
        tabIcons[donneesPrevisions[index].weatherConditionCode.toString()]['icon'],
        Text(textAlign: TextAlign.center, textScaleFactor: 0.8, donneesPrevisions[index].weatherDescription ?? ""), // verification non null
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(textScaleFactor: 0.8, '${tempMin.toStringAsFixed(1)}°C'),
            Text(textScaleFactor: 0.8, '${tempMax.toStringAsFixed(1)}°C'),
          ],
        ),
      ],
    );
  }
}

class WidgetDayLong extends StatelessWidget {
  const WidgetDayLong({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String jour = jourSemaine[donneesJour.date?.weekday ?? 0];
    jour += ' ';
    jour += donneesJour.date?.day.toString() ?? "";
    return SizedBox(
      width: 100,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(5),
            Text(jour),
            tabIcons[donneesJour.weatherConditionCode.toString()]['icon'],
            Text(textAlign: TextAlign.center, textScaleFactor: 0.8, donneesJour.weatherDescription ?? ""), // verification non null
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(textScaleFactor: 0.8, '${donneesJour.temperature?.celsius?.toStringAsFixed(1)}°C'),
                Text(textScaleFactor: 0.8, '${donneesJour.humidity.toString()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetDayGraphe extends StatefulWidget {
  const WidgetDayGraphe({
    super.key,
  });

  @override
  State<WidgetDayGraphe> createState() => _WidgetDayGrapheState();
}

class _WidgetDayGrapheState extends State<WidgetDayGraphe> {
  List<ChartData> chartData = [
    ChartData('0', 0),
    ChartData('0', 0),
    ChartData('0', 0),
    ChartData('0', 0),
    ChartData('0', 0),
    ChartData('0', 0),
    ChartData('0', 0),
    ChartData('0', 0),
  ];

  @override
  Widget build(BuildContext context) {
    int i;
    double tempMin = 100;
    double tempMax = 0;

    tempMin = min(tempMin, donneesJour.tempMin?.celsius ?? 0);
    tempMax = max(tempMax, donneesJour.tempMax?.celsius ?? 0);
    for (i = 0; i < 8; i++) {
      String stringToken;
      double? mesure = donneesPrevisions[i].temperature?.celsius;
      stringToken = mesure!.toStringAsFixed(1);
      mesure = double.parse(stringToken);
      chartData[i] = ChartData(donneesPrevisions[i].date!.hour.toString(), mesure);
    }
    return Expanded(
      child: Card(
        child: SizedBox(
          height: 150,
          width: 200,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              // Renders spline chart
              SplineSeries<ChartData, String>(
                  markerSettings: const MarkerSettings(isVisible: true, height: 2, width: 2),
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
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
  if (etatJour == DownloadState.finishedDownloading && etatPrevisions == DownloadState.finishedDownloading) {
    return const RowJourWidget();
  } else {
    return contentDownloading();
  }
}

Widget affichageResultatsPrevisions() {
  if (etatPrevisions == DownloadState.finishedDownloading) {
    return const RowPrevisionsWidget();
  } else {
    return contentDownloading();
  }
}
