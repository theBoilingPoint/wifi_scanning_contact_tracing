import 'package:collection/collection.dart';
import 'package:wifi_scanning_flutter/data/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/services/cloud_database.dart';

class WifiMatching {
  WifiDao wifiDao = WifiDao();
  /*
  * @param timeSpan is the of type Duration
  */
  Future<bool> matchFingerprints(String uid, Duration timeSpan,
      double filterPercentage, double similarityThreshold) async {
    //Get raw data from cloud and local dbs
    List<CustomisedWifi> rawLocalWifiList =
        await wifiDao.getAllSortedBy("dateTime");
    List<CustomisedWifi> rawCloudWifiList =
        await DatabaseService(uid: uid).getAllScansFromCloudMadeByOtherUsers();
    // print("Raw local data: ");
    // rawLocalWifiList.forEach((element) => print(
    //     "dateTime: ${element.dateTime} BSSID: ${element.bssid} RSSI: ${element.rssi}"));
    // print("raw cloud data: ");
    // rawCloudWifiList.forEach((element) => print(
    //     "dateTime: ${element.dateTime} BSSID: ${element.bssid} RSSI: ${element.rssi}"));

    //Find all data in the cloud and local dbs that match each other's timestamp
    //Datatype here is set because we don't my repetitive data
    Set<CustomisedWifi> matchedCloudWifiList = {};
    Set<CustomisedWifi> matchedLocalWifiList = {};
    rawLocalWifiList.forEach((localScan) {
      DateTime localTimestamp = DateTime.parse(localScan.dateTime);
      rawCloudWifiList.forEach((cloudScan) {
        DateTime cloudTimestamp = DateTime.parse(cloudScan.dateTime);
        if(localTimestamp.difference(cloudTimestamp) <= timeSpan) {
          //print("Local Timestamp: ${localTimestamp.toString()} Cloud Timestamp: ${cloudTimestamp.toString()}");
          matchedCloudWifiList.add(cloudScan);
          matchedLocalWifiList.add(localScan);
        }
      });
    });
    print("Matched Local List: ");
    matchedLocalWifiList.forEach((element) => print(
        "dateTime: ${element.dateTime} BSSID: ${element.bssid} RSSI: ${element.rssi}"));
    print("Matched Cloud List: ");
    matchedCloudWifiList.forEach((element) => print(
        "dateTime: ${element.dateTime} BSSID: ${element.bssid} RSSI: ${element.rssi}"));

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
      //print("Cur cloud timestamp: " + cloudScanKey.toString());
      groupedLocalWifiList.entries.forEach((localScan) {
        if (cloudScanKey.difference(DateTime.parse(localScan.key)) <=
            timeSpan) {
          //print("Found a matched timestamp");
          if (computeSimilarityBetweenLists(
                  cloudScan.value, localScan.value, filterPercentage) >=
              similarityThreshold) {
            //print("Similarity accepted");
            hasMatch = true;
          }
        }
      });
    });

    return hasMatch;
  }

  double computeSimilarityBetweenLists(
      List<CustomisedWifi> la, List<CustomisedWifi> lb, filterPercentage) {
    List<CustomisedWifi> filteredLstA = filterWifiByRssi(la, filterPercentage);
    List<CustomisedWifi> filteredLstB = filterWifiByRssi(lb, filterPercentage);
    print("Filtered List a");
    filteredLstA.forEach((element) => print(
        "dateTime: ${element.dateTime} BSSID: ${element.bssid} RSSI: ${element.rssi}"));
    print("Filtered List b");
    filteredLstB.forEach((element) => print(
        "dateTime: ${element.dateTime} BSSID: ${element.bssid} RSSI: ${element.rssi}"));
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
