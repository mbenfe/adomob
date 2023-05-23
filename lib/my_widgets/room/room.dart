import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../m_define.dart';
import '../../my_animations/my_animations.dart';
import '../../my_models/complex_state_fz.dart';
import '../state_notifier.dart';

/// ConsumerWidget for riverpod
class RootRoomWidget extends ConsumerWidget {
  const RootRoomWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);

  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;
  final String master;

  @override
  Widget build(BuildContext context, ref) {
    final Map<String, IconData> slotMapIcons = {
      'Matin': MdiIcons.weatherSunset,
      'Journee': MdiIcons.weatherSunny,
      'Soir': MdiIcons.weatherSunsetDown,
      'Nuit': MdiIcons.weatherNight
    };

    final Map<String, IconData> periodMapIcons = {
      'Semaine': MdiIcons.alphaSBoxOutline,
      'Weekend': MdiIcons.alphaWBoxOutline,
    };

    int index;
    Map<String, dynamic>? teleJsonMapMaster = {}; //* donnée du Master : capteur de temperature
    List<Map<String, dynamic>> teleListJsonSlave = []; //* données des Slaves: switch

    Map<String, JsonForMqtt> mapState = {};

    //* recuperation des données ETAT -> mapState
    for (index = 0; index < listStateProviders.length; index++) {
      JsonForMqtt intermediate = ref.watch(listStateProviders[index]);
      if (intermediate.teleJsonMap.isNotEmpty && intermediate.teleJsonMap.containsKey('Name')) {
        mapState.addAll({intermediate.teleJsonMap['Name']: intermediate});
      }
    }

    teleJsonMapMaster = mapState[master]?.teleJsonMap;
    //! a revoir
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    for (index = 0; index < listSlaves.length; index++) {
      var temp = mapState[listSlaves[index]]?.teleJsonMap;
      if (temp != null) {
        teleListJsonSlave.add(temp);
      }
    }

    Color couleurBordure = Colors.amber;

    String currentPeriod = 'WEEKEND'; //* valeur par defaut  pour test
    String currentSlot = 'NUIT'; //* valeur par defaut pour test
    //* slection des icons selon l'heure/jour
    final time = DateTime.now();
    IconData slotIcon = MdiIcons.help;
    IconData periodIcon = MdiIcons.help;
    if (time.hour >= 6 && time.hour < 9) {
      currentSlot = 'MATIN';
      slotIcon = slotMapIcons['Matin']!;
    }
    if (time.hour >= 9 && time.hour < 17) {
      currentSlot = 'JOURNEE';
      slotIcon = slotMapIcons['Journee']!;
    }
    if (time.hour >= 17 && time.hour < 23) {
      currentSlot = 'SOIR';
      slotIcon = slotMapIcons['Soir']!;
    }
    if (time.hour >= 23 || time.hour < 6) {
      currentSlot = 'NUIT';
      slotIcon = slotMapIcons['Nuit']!;
    }
    if (time.weekday < 6) {
      currentPeriod = 'SEMAINE';
      periodIcon = periodMapIcons['Semaine']!;
    } else {
      currentPeriod = 'WEEKEND';
      periodIcon = periodMapIcons['Weekend']!;
    }

    //* define the target temperature
    double targetTemp = 20;

    int i;
    bool trouve = false;
    if (mapState.isNotEmpty) {
      for (i = 0; i < listSlaves.length; i++) {
        if (mapState.containsKey(listSlaves[i])) {
          trouve = true;
          break;
        }
      }

      if (trouve == true) {
        List<Map<String, dynamic>> slave = mapState[listSlaves[i]]?.listOtherJsonMap as List<Map<String, dynamic>>;

        for (i = 0; i < slave.length; i++) {
          if (slave[i]['TYPE'] == currentPeriod) {
            targetTemp = slave[i][currentSlot].toDouble();
          }
        }
      }
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onLongPress: () {
            HapticFeedback.heavyImpact();
            if (kDebugMode) print('pressed');
            couleurBordure == Colors.amber ? couleurBordure = Colors.red : couleurBordure = Colors.amber;
            for (int i = 0; i < listSlaves.length; i++) {
              mapState[listSlaves[i]]?.classSwitchToggle();
            }
          },
          child: Container(
            width: ROOM_WIDGET_SIZE,
            height: ROOM_WIDGET_SIZE,
            decoration: BoxDecoration(
                border: Border.all(color: couleurBordure, width: 5),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(60),
                  topLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60 / 2),
                  bottomLeft: Radius.circular(60 / 2),
                )),
            // gauge
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (teleJsonMapMaster != null && teleListJsonSlave.isNotEmpty) ...[
                  Positioned(
                    top: INSET_GAUGE,
                    child: RoomGauge(
                        gWidth: ROOM_WIDGET_SIZE - 2 * 5 - 2 * INSET_GAUGE,
                        gHeight: ROOM_WIDGET_SIZE / 2,
                        color: Colors.red,
                        trim: false,
                        radius: 60,
                        epaisseur: 10,
                        targetTemp: targetTemp,
                        //                    temperature: decodeSensor['temp']),
                        temperature: teleJsonMapMaster['Temperature'].toDouble()),
                  ),
                  // text temperature
                  //                 Positioned(top: 40, left: 60, child: Text(teleJsonMapMaster['LinkQuality'].toString(), style: const TextStyle(fontSize: 10))),
                  Positioned(
                      top: 70,
                      child: Text(teleJsonMapMaster['Temperature'] != null ? teleJsonMapMaster['Temperature'].toStringAsFixed(2) + '°C' : '--°C',
                          style: const TextStyle(fontSize: 20))),
                  Positioned(
                      top: 50,
                      right: 40,
                      child: Text(teleJsonMapMaster['Humidity'] != null ? teleJsonMapMaster['Humidity'].toStringAsFixed(0) + '%' : '--%',
                          style: const TextStyle(fontSize: 14))),
                  // etat du chauffage
                  Positioned(top: 105, child: Text(location, style: const TextStyle(fontSize: 12))),
                  Positioned(
                      top: 67,
                      right: 69,
                      child: teleListJsonSlave[0]['Power'] == 1 ? const IconHeaterAnimated(etat: true) : const IconHeaterAnimated(etat: false)),
                  Positioned(
                    top: 125,
                    left: 50,
                    child: Icon(
                      slotIcon,
                      size: 35,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Positioned(
                    top: 127,
                    left: 85,
                    child: Icon(periodIcon, size: 35, color: Colors.blueAccent),
                  ),
                  const Positioned(
                    top: 120,
                    right: 6,
                    child: BuildIcons(),
                  )
                ]
              ],
            ),
          ),
        );
      },
      // containter frame
    );
  }
}

void initDataCanvas(double width, double height) {}

/// ConsumerWidget for riverpod
class RoomGauge extends ConsumerWidget {
  const RoomGauge(
      {Key? key,
      required this.gWidth,
      required this.gHeight,
      required this.color,
      required this.trim,
      required this.radius,
      required this.epaisseur,
      required this.temperature,
      required this.targetTemp})
      : super(key: key);

  final Color color;
  final double epaisseur;
  final double gHeight;
  final double gWidth;
  final double radius;
  final double targetTemp;
  final double temperature;
  final bool trim;

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        Stack(
          children: [
            CustomPaint(
              size: Size(gWidth, gHeight),
//              painter: TickPainter(60 - INSET_GAUGE * 1.5, room.modeThermostat, room.modeManual),
              painter: TickPainter(60 - INSET_GAUGE * 1.5, targetTemp, false), // 60 <- radius angle widget
            ),
            CustomPaint(
              size: Size(gWidth, gHeight),
              painter: GaugePainter(color, trim, 60 - INSET_GAUGE * 1.5, epaisseur, temperature), // 60 <- radius angle widget
            ),
          ],
        ),
      ],
    );
  }
}

class BuildIcons extends StatelessWidget {
  const BuildIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
      Transform.rotate(
        angle: -45 * pi / 180,
        child: IconButton(
          iconSize: 30,
          color: Colors.green,
          icon: const Icon(Icons.link), //room.modeLinked ? const Icon(Icons.link) : const Icon(Icons.link_off),
          onPressed: () => {}, //room.modeLinked ? roomNotifier.setLink(false) : roomNotifier.setLink(true))),
        ),
      )
    ]);
  }
}

/// *************************** GAUGE **************************************
class GaugePainter extends CustomPainter {
  GaugePainter(this.color, this.trim, this.radius, this.epaisseur, this.temperature);

  final Color color;
  final double epaisseur;
  final double radius;
  final double temperature;
  final bool trim;

  @override
  void paint(Canvas canvas, Size size) {
    int i = 0;
    const double shrink = INSET_TEXT_TEMP; // temp
    // painters

    // final boxPaint = Paint()          // for test
    //   ..color = color                 // for test
    //   ..strokeWidth = 5 //epaisseur   // for test
    //   ..style = PaintingStyle.stroke; // for test

    final activePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = epaisseur
      ..style = PaintingStyle.stroke;
    final inactivePaint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = epaisseur
      ..style = PaintingStyle.stroke;
    // paths
    //  final boxPath = Path();   // for test
    var framePath = Path();
    final inactivePath = Path();
    final activePath = Path();

    // path definition

    double pointeurTemperature;

    // boxPath.lineTo(0, size.height);           // for test
    // boxPath.lineTo(size.width, size.height);  // for test
    // boxPath.lineTo(size.width, 0);            // for test
    // boxPath.lineTo(0, 0);                     // for test
    // path definition
    framePath.moveTo(0, size.height);
    framePath.lineTo(0, radius);
    framePath.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    framePath.lineTo(size.width - radius, 0);
    framePath.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    framePath.lineTo(size.width, size.height);

    double dashWidth = 10.0;
    double dashSpace = 1.0;
    double distance = 0.0;

    // draw inactive gauge
    for (PathMetric pathMetric in framePath.computeMetrics()) {
      dashWidth = (pathMetric.length - 20) / 20;
      while (distance < pathMetric.length) {
        inactivePath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    for (PathMetric pathMetric in framePath.computeMetrics()) {
      dashWidth = (pathMetric.length - 20) / 20;
      distance = 0;
      pointeurTemperature = pathMetric.length * (temperature - MIN_TEMP) / (MAX_TEMP - MIN_TEMP);
      while (distance < pointeurTemperature) {
        activePath.addPath(
          pathMetric.extractPath(distance, pointeurTemperature - distance >= dashWidth ? distance + dashWidth : pointeurTemperature),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    //  canvas.drawPath(boxPath, boxPaint);    // canvas for test
    canvas.drawPath(inactivePath, inactivePaint);
    canvas.drawPath(activePath, activePaint);

    PathMetrics framePathMetrics = framePath.computeMetrics();
    for (PathMetric framePathMetric in framePathMetrics) {
      for (i = 0; i < 11; i++) {
        Path extractedPath = framePathMetric.extractPath(0, max(1, framePathMetric.length * 0.1 * i));

        var metric = extractedPath.computeMetrics().first;

        try {
          Offset offset = const Offset(0, 0);
          offset = metric.getTangentForOffset(metric.length)!.position;
          final angle = metric.getTangentForOffset(metric.length)!.angle; // radiant

          offset = offset.translate(shrink * sin(angle), shrink * cos(angle));

          TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 10), text: '${(i + MIN_TEMP).toInt()}°');
          TextPainter textPainter = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);

          textPainter.layout(minWidth: 0, maxWidth: 50);

          offset = offset.translate(-(textPainter.width / 2), -(textPainter.height / 2));

          textPainter.paint(canvas, offset);
        } catch (e) {
          if (kDebugMode) {
            print('erreur:$e');
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// *************************** THERMOSTAT *********************************
class TickPainter extends CustomPainter {
  TickPainter(this.radius, this.targetTemp, this.isManual);

  final bool isManual;
  final double radius;
  final double targetTemp;

  @override
  void paint(Canvas canvas, Size size) {
    // painters
    final tickPaint = Paint()
      ..color = isManual ? Colors.red : Colors.green
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    // paths
    Path framePath = Path();

    // path definition
    framePath.moveTo(0, size.height);
    framePath.lineTo(0, radius);
    framePath.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    framePath.lineTo(size.width - radius, 0);
    framePath.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    framePath.lineTo(size.width, size.height);
    // canvas.drawPath(framePath, tickPaint);
    PathMetrics framePathMetrics = framePath.computeMetrics();
    for (PathMetric framePathMetric in framePathMetrics) {
      // ignore: todo
      // TODO: check why 0,0 don't work and require max
      Path extractedPath = framePathMetric.extractPath(0, max(1, framePathMetric.length * (targetTemp - MIN_TEMP) / (MAX_TEMP - MIN_TEMP)));

      var metric = extractedPath.computeMetrics().first;

      try {
        Offset offset = const Offset(0, 0);
        offset = metric.getTangentForOffset(metric.length)!.position;
        final angle = metric.getTangentForOffset(metric.length)!.angle; // radiant
        // ignore: todo
        // TODO: malek a changer en fonction de l'epaisseur
        offset = offset.translate(5 * sin(angle), 5 * cos(angle));
        Path thermostatPath = thermostatTick(angle);
        thermostatPath = thermostatPath.shift(offset);
        canvas.drawPath(thermostatPath, tickPaint);
      } catch (e) {
        if (kDebugMode) {
          print('erreur:$e');
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Path thermostatTick(double angle) {
  // Path newPath = Path();
  final newPath = Path();
  Offset A, B, C, D, E;
  A = myTranslate(0, 0, -angle);
  B = myTranslate(5, 5, -angle);
  C = myTranslate(5, 15, -angle);
  D = myTranslate(-5, 15, -angle);
  E = myTranslate(-5, 5, -angle);

  // path definition
  newPath.moveTo(A.dx, A.dy);
  newPath.lineTo(B.dx, B.dy);
  newPath.lineTo(C.dx, C.dy);
  newPath.arcToPoint(
    Offset(D.dx, D.dy),
    radius: const Radius.circular(10),
    clockwise: true,
  );
  newPath.lineTo(E.dx, E.dy);
  newPath.close();
  newPath.fillType;
  return newPath;
}

Offset myTranslate(double x, double y, double angle) {
  Offset offset = Offset(x * cos(angle) - y * sin(angle), x * sin(angle) + y * cos(angle));
  return offset;
}
