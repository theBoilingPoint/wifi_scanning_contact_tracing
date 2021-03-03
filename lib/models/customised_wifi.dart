class CustomisedWifi {
  String dateTime;
  String ssid;
  String bssid;
  int rssi;
  int frequency;

  CustomisedWifi(this.dateTime, this.ssid, this.bssid, this.rssi, this.frequency);

  Map<String, dynamic> toMap() => {
    "dateTime": dateTime,
    "ssid": ssid,
    "bssid": bssid,
    "rssi": rssi,
    "frequency": frequency
  };

  static CustomisedWifi fromMap(Map<String, dynamic> map){
    return CustomisedWifi(
      map['dateTime'],
      map['ssid'],
      map['bssid'],
      map['rssi'],
        map['frequency']
    );
  }
}