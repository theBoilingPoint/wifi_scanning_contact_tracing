import 'package:collection/collection.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanning_flutter/data/result_dao.dart';
import 'package:wifi_scanning_flutter/data/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_result.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/services/cloud_database.dart';

class DatabaseOperations {
  WifiDao wifiDao = WifiDao();
  ResultDao resultDao = ResultDao();

  Future<List<WifiResult>> scanWifi() async {
    return await Wifi.list('');
  }

  Future<void> storeScansInLocalDatabase(List<WifiResult> ssidList) async {
    String timeStamp = DateTime.now().toString();
    for (var i = 0; i < ssidList.length; i++) {
      CustomisedWifi curWifi = new CustomisedWifi(timeStamp, ssidList[i].ssid,
          ssidList[i].bssid, ssidList[i].level, ssidList[i].frequency);
      await wifiDao.insert(curWifi);
    }
  }

  Future<void> uploadScansToCloud(String userId) async {
    List<CustomisedWifi> wifiListInDatabase =
        await wifiDao.getAllSortedBy("dateTime");
    Map<String, List<CustomisedWifi>> groupedwifiList = groupBy(
        wifiListInDatabase, (CustomisedWifi eachSignal) => eachSignal.dateTime);
    Map<String, List<Map>> newGroupedWifiList = Map();
    groupedwifiList.forEach((key, value) {
      List<Map> newValue = [];
      value.forEach((element) {
        newValue.add(element.toMap());
      });
      newGroupedWifiList[key] = newValue;
    });

    await DatabaseService(uid: userId).updateUserData(newGroupedWifiList);
  }

  Future<void> insertResultToDb(CustomisedResult result) async {
    await resultDao.insert(result);
  }

  void printWiFiListInLocalDatabase() async {
    List wifiListInDatabase = await wifiDao.getAllSortedBy("dateTime");
    wifiListInDatabase.forEach((element) {
      print(
          "Time: ${element.dateTime} SSID: ${element.ssid} BSSID: ${element.bssid} RSSI: ${element.rssi} Frequency: ${element.frequency}");
    });
  }

  void clearLocalDataBase() {
    wifiDao.deleteAll();
  }

  Future<void> clearCloudDataBase(String userId) async {
    await DatabaseService(uid: userId).deleteAllScansOfCurrentUser();
  }
}
