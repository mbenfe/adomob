// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:my_adomob/m_init_mqtt_devices_app.dart';

class MqttTelegram {
  String topicRoot = ""; // gw = tasmota gateway, app = application, adomelec = gestion
  String topicLocation = ""; // all
  String topicCustomer = ""; // all
  String topicDevice = "";
  String topicType = ""; // telemetry
  String mesureFlag = ""; // telemetry
  String payload = ""; // all
}

class MQTTClientManager {
  String server;
  String name;
  int port;
  MQTTClientManager({
    required this.server,
    required this.name,
    required this.port,
  });

//  MqttServerClient client = MqttServerClient.withPort('82.64.178.10', 'gestor-adomob', 1883);
  MqttServerClient client = MqttServerClient.withPort('82.64.178.10', 'gestor-adomob', 1883);

  Future<int> connect() async {
    client.logging(on: false);
    client.keepAlivePeriod = 300; // 5 minutes
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      if (kDebugMode) {
        print('MQTTClient:$name:Client exception - $e');
      }
      client.disconnect();
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('MQTTClient:$name:Socket exception - $e');
      }
      client.disconnect();
    }

    return 0;
  }

  void disconnect() {
    client.disconnect();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void onConnected() {
    if (kDebugMode) {
      print('MQTTClient:$name:Connected');
    }
  }

  void onDisconnected() {
    if (kDebugMode) {
      print('MQTTClient:$name:Disconnected');
    }
  }

  void onSubscribed(String topic) {
    if (kDebugMode) {
      print('MQTTClient:$name:Subscribed to topic: $topic');
    }
  }

  void pong() {
    if (kDebugMode) {
      print('MQTTClient:$name:Ping response received');
    }
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(retain: true, topic, MqttQos.exactlyOnce, builder.payload!);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }
}

void publishMqtt(String topic, String payload) {
  appMqttClientManager.publishMessage(topic, payload);
  if (kDebugMode) {
    print('publish -> topic: $topic payload: $payload');
  }
}
