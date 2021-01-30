class CustomisedUser {
  final String uid;
  bool state = false;
  DateTime dateTime;
  String ssid;
  String rssi;

  CustomisedUser(this.uid);

  String get userId {
    return uid;
  }

  bool get infectionState {
    return state;
  }

  set infectionState(bool currentState) {
    state = currentState;
  }

  set currentDateTime(DateTime now) {
    dateTime = now;
  }

  set wifiSSID(String ssid) {
    this.ssid = ssid;
  }

  set wifiRSSI(String rssi) {
    this.rssi = rssi;
  }

  Map<String, dynamic> toMap() => {
    "id": uid,
    "state": state,
    "dateTime": dateTime,
    "ssid": ssid,
    "rssi": rssi,
  };

  static CustomisedUser fromMap(Map<String, dynamic> map){
    return CustomisedUser(map['id']);
  }

}