import 'package:collection/collection.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanning_flutter/services/database/result_dao.dart';
import 'package:wifi_scanning_flutter/services/database/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_result.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/services/database/cloud_database.dart';

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

  Future<List<CustomisedWifi>> getLocalDbBy(String field) async {
    return await wifiDao.getAllSortedBy(field);
  }

  Future<List<CustomisedResult>> getResultDbBy(String field) async {
    return await resultDao.getAllSortedBy(field);
  }

  void clearLocalDatabase() {
    wifiDao.deleteAll();
  }

  void clearResultDatabase() {
    resultDao.deleteAll();
  }

  Future<void> clearCloudDatabase(String userId) async {
    await DatabaseService(uid: userId).deleteAllScansOfCurrentUser();
  }
}
