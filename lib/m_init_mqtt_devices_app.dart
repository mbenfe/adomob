import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'm_analyse_mqtt.dart';
import 'm_define.dart';
import 'm_build_from_json.dart';
import 'my_mqtt/mqtt_handler.dart';

MQTTClientManager appMqttClientManager = MQTTClientManager(server: '82.64.178.10', name: 'admob', port: 1883);
// mqtt topic for configuring mobile application
const String subscribConfigTopic = "app_config/$client/$ville/#";
const String publishConfigTopic = "app_config/$client/$ville";
// mqtt topic when running application
const String subscribGatewayTopic = "gw/$client/$ville/#";
const String publishGatewayTopic = "gw/$client/$ville";

/// ************************************root initialisation gestor ****************************
void appInitialisation() {
  /// async call connection mqtt
  asyncSetMqttClient();

  /// dirige les future message recus vers la fonction gestor
  setupAppUpdatesListener();

  return;
}

Future<int> asyncSetMqttClient() async {
  if (kDebugMode) {
    print("ADOMOB:INIT: MQTT demande subscription...");
  }
  await appMqttClientManager.connect();
  appMqttClientManager.subscribe(subscribConfigTopic);
  if (kDebugMode) {
    print("ADOMOB:INIT: MQTT subscribed to $subscribConfigTopic");
  }
  return 0;
}

void setupAppUpdatesListener() {
  if (kDebugMode) {
    print("ADOMOB::setup mqtt listener");
  }

  appMqttClientManager.getMessagesStream()!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    final topic = c[0].topic.toString();
    appAnalyseReceivedMqtt(topic, payload);
  });
}

class AppInit {
  static Future initialize() async {
    await _loadConfig();
  }

  static _loadConfig() async {
    do {
      await Future.delayed(const Duration(seconds: 1));
    } while (//listBundles.isEmpty ||
        listBundles.isEmpty);
  }
}
