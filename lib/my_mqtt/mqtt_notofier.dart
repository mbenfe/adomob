part of my_mqtt;

final mqttProvider = ChangeNotifierProvider<MqttChangeNotifier>((ref) => MqttChangeNotifier());

class MqttChangeNotifier extends ChangeNotifier {
  MqttChangeNotifier([
    this.topic = "",
    this.payload = "",
  ]);

  String topic;
  String payload;

  void setReceived(newTopic, newPayload) {
    topic = newTopic;
    payload = newPayload;
    notifyListeners();
  }
}

void nodifyMessageReceived(String topic, String payload) {}
