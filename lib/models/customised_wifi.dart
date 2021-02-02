class CustomisedWifi {
  String dateTime;
  String ssid;
  int rssi;

  CustomisedWifi(this.dateTime, this.ssid, this.rssi);

  Map<String, dynamic> toMap() => {
    "dateTime": dateTime,
    "ssid": ssid,
    "rssi": rssi
  };

  static CustomisedWifi fromMap(Map<String, dynamic> map){
    return CustomisedWifi(
      map['dateTime'],
      map['ssid'],
      map['rssi']
    );
  }
}