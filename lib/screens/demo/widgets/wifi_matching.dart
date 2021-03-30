import 'package:collection/collection.dart';
import 'package:wifi_scanning_flutter/services/database/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/services/database/cloud_database.dart';

class WifiMatching {
  WifiDao wifiDao = WifiDao();
  double similarity = 0;
  /*
  * @param timeSpan is the of type Duration
  */
  Future<bool> matchFingerprints(String uid, Duration timeSpan,
      double filterPercentage, double similarityThreshold) async {
    //Get raw data from cloud and local dbs5
    List<CustomisedWifi> rawLocalWifiList =
        await wifiDao.getAllSortedBy("dateTime");
    List<CustomisedWifi> rawCloudWifiList =
        await CloudDatabase(uid: uid).getAllScansFromCloudMadeByOtherUsers();

    //Find all data in the cloud and local dbs that match each other's timestamp
    //Datatype here is set because we don't my repetitive data
    Set<CustomisedWifi> matchedCloudWifiList = {};
    Set<CustomisedWifi> matchedLocalWifiList = {};
    rawLocalWifiList.forEach((localScan) {
      DateTime localTimestamp = DateTime.parse(localScan.dateTime);
      rawCloudWifiList.forEach((cloudScan) {
        DateTime cloudTimestamp = DateTime.parse(cloudScan.dateTime);
        if (localTimestamp.difference(cloudTimestamp) <= timeSpan) {
          matchedCloudWifiList.add(cloudScan);
          matchedLocalWifiList.add(localScan);
        }
      });
    });

    //Group the lists by timestamps
    Map<String, List<CustomisedWifi>> groupedCloudWifiList = groupBy(
        matchedCloudWifiList,
        (CustomisedWifi eachSignal) => eachSignal.dateTime);
    Map<String, List<CustomisedWifi>> groupedLocalWifiList = groupBy(
        matchedLocalWifiList,
        (CustomisedWifi eachSignal) => eachSignal.dateTime);
    //Dart does not support non-local returns,
    //so returning from a callback won't break the loop. Dart forEach callback returns void.
    bool hasMatch = false;
    groupedCloudWifiList.entries.forEach((cloudScan) {
      DateTime cloudScanKey = DateTime.parse(cloudScan.key);
      groupedLocalWifiList.entries.forEach((localScan) {
        if (cloudScanKey.difference(DateTime.parse(localScan.key)) <=
            timeSpan) {
          similarity = computeSimilarityBetweenLists(
                  cloudScan.value, localScan.value, filterPercentage);
          if (similarity >= similarityThreshold) {
            hasMatch = true;
          }
        }
      });
    });

    return hasMatch;
  }

  double computeSimilarityBetweenLists(
      List<CustomisedWifi> la, List<CustomisedWifi> lb, filterPercentage) {
    List<String> filteredLstA = filterWifiByRssi(la, filterPercentage).map((e) => e.bssid).toList();
    List<String> filteredLstB = filterWifiByRssi(lb, filterPercentage).map((e) => e.bssid).toList();

    double similarity = 0;
    if (filteredLstA.length <= filteredLstB.length) {
      double increment = 1 / filteredLstA.length;
      filteredLstA.forEach((element) {
        if (filteredLstB.contains(element)) {
          similarity += increment;
        }
      });
    } else {
      double increment = 1 / filteredLstB.length;
      filteredLstB.forEach((element) {
        if (filteredLstA.contains(element)) {
          similarity += increment;
        }
      });
    }

    return similarity;
  }

  List<CustomisedWifi> filterWifiByRssi(
      List<CustomisedWifi> lst, filterPercentage) {
    List<CustomisedWifi> temp = lst;
    //sort the wifi list according to rssi in descending order
    temp..sort((e1, e2) => e2.rssi.compareTo(e1.rssi));
    //keep only the strongest n% in the list and return it
    return temp.take((temp.length * filterPercentage).toInt()).toList();
  }
}
