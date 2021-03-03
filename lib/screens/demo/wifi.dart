import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanning_flutter/data/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/services/cloud_database.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key wifiList}): super(key: wifiList);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int level = 0;
  List<WifiResult> ssidList = [];
  WifiDao wifiDao = WifiDao();
  bool isInfected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);
    final Color kingsBlue = HexColor('#0a2d50');
    final Color kingsPearlGrey = HexColor("cdd7dc");

    return
      // StreamProvider<QuerySnapshot>.value(
      // value: DatabaseService().users,
      // child:
      Scaffold(
        appBar: AppBar(
          title: Text("WiFi List"),
          centerTitle: true,
          backgroundColor: kingsBlue,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.leak_add,
                  color: kingsPearlGrey,
                ),
                onPressed: () {
                  clearLocalDataBase();
                })
          ],
        ),
        body: Container(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: ssidList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(
                      "BSSID: ${ssidList[index].bssid} RSSI: ${ssidList[index].level}dBm Frequency: ${ssidList[index].frequency}MHz"));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings_input_antenna),
          onPressed: () async {
            await loadData();
            //storeScansInLocalDatabase();
            //storeScansWithin7DaysInCloudDatabase(user.uid);
            //printGroupedCurrentLocalList();
            printWiFiListInLocalDatabase();
          },
        ),
      );
    //);
  }

  Function listCompare = const ListEquality().equals;


  Future<void> loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
      });
    });
  }

  /*
  * @param timeSpan is the of type Duration
  */
  Future<bool> matchFingerprints(String uid, Duration timeSpan, double filterPercentage, double similarityThreshold) async {
    //Get raw data from cloud and local dbs
    List<CustomisedWifi> rawLocalWifiList = await wifiDao.getAllSortedByTime();
    List<CustomisedWifi> rawCloudWifiList = await DatabaseService(uid: uid).getAllScansFromCloud();

    //Find all data in the cloud and local dbs that match each other's timestamp
    //Datatype here is set because we don't my repetitive data
    Set<CustomisedWifi> matchedCloudWifiList = {};
    Set<CustomisedWifi> matchedLocalWifiList = {};
    rawCloudWifiList.forEach((cloudWifi) {
      DateTime cloudScanTime = DateTime.parse(cloudWifi.dateTime);
      rawLocalWifiList.forEach((curWifi) {
        DateTime curScanTime = DateTime.parse(curWifi.dateTime);
        if(cloudScanTime.difference(curScanTime) <= timeSpan) {
          matchedCloudWifiList.add(cloudWifi);
          matchedLocalWifiList.add(curWifi);
        }
      });
    });

    //Group the lists by timestamps
    Map<String, List<CustomisedWifi>> groupedCloudWifiList = groupBy(matchedCloudWifiList, (CustomisedWifi eachSignal) => eachSignal.dateTime);
    Map<String, List<CustomisedWifi>> groupedLocalWifiList = groupBy(matchedLocalWifiList, (CustomisedWifi eachSignal) => eachSignal.dateTime);
    groupedCloudWifiList.entries.forEach((cloudScan) {
      DateTime cloudScanKey = DateTime.parse(cloudScan.key);
      groupedLocalWifiList.entries.forEach((localScan) {
        if(cloudScanKey.difference(DateTime.parse(localScan.key)) <= timeSpan) {
          if(computeSimilarityBetweenLists(cloudScan.value, localScan.value, filterPercentage) >= similarityThreshold) {
            return true;
          }
        }
      });
    });

    return false;
  }

  double computeSimilarityBetweenLists(List<CustomisedWifi> la, List<CustomisedWifi> lb, filterPercentage) {
    List<CustomisedWifi> filteredLstA = filterWifiByRssi(la, filterPercentage);
    List<CustomisedWifi> filteredLstB = filterWifiByRssi(lb, filterPercentage);
    double similarity = 0;
    if(filteredLstA.length <= filteredLstB.length) {
      double increment = 1/filteredLstA.length;
      filteredLstA.forEach((element) {
        if(filteredLstB.contains(element)){
          similarity+=increment;
        }
      });
    }
    else{
      double increment = 1/filteredLstB.length;
      filteredLstB.forEach((element) {
        if(filteredLstA.contains(element)){
          similarity+=increment;
        }
      });
    }
    return similarity;
  }

  List<CustomisedWifi> filterWifiByRssi(List<CustomisedWifi> lst, filterPercentage) {
    List<CustomisedWifi> temp = lst;
    //sort the wifi list according to rssi in descending order
    temp..sort((e1, e2) => e2.rssi.compareTo(e1.rssi));
    //keep only the strongest n% in the list and return it
    return temp.take((temp.length*filterPercentage).toInt()).toList();
  }

  Future<void> printGroupedCurrentLocalList() async {
    List<CustomisedWifi> wifiListInDatabase = await wifiDao.getAllSortedByTime();
    var groupedwifiList = groupBy(wifiListInDatabase, (CustomisedWifi eachSignal) => eachSignal.dateTime);
    groupedwifiList.forEach((key, value) => print("Key: $key Value: $value"));
  }

  void storeScansInLocalDatabase(){
    String timeStamp = DateTime.now().toString();
    for(var i = 0; i < ssidList.length; i++){
      CustomisedWifi curWifi = new CustomisedWifi(timeStamp, ssidList[i].ssid, ssidList[i].bssid, ssidList[i].level, ssidList[i].frequency);
      wifiDao.insert(curWifi);
    }
  }

  Future<void> storeScansWithin7DaysInCloudDatabase(userId) async {
    List<CustomisedWifi> wifiListInDatabase = await wifiDao.getScansWithin7Days();
    Map<String, List<CustomisedWifi>> groupedwifiList = groupBy(wifiListInDatabase, (CustomisedWifi eachSignal) => eachSignal.dateTime);
    Map<String, List<Map>> newGroupedWifiList = Map();
    groupedwifiList.forEach((key, value) {
      List<Map> newValue = [];
      value.forEach((element) {
        newValue.add({
          'ssid': element.ssid,
          'bssid': element.bssid,
          'rssi': element.rssi,
          'frequency': element.frequency
        });
      });
      newGroupedWifiList[key] = newValue;
    });

    await DatabaseService(uid: userId).updateUserData(newGroupedWifiList);
  }

  void printWiFiListInLocalDatabase() async {
    List wifiListInDatabase = await wifiDao.getAllSortedByTime();
    wifiListInDatabase.forEach((element) {
      print("Time: ${element.dateTime} SSID: ${element.ssid} BSSID: ${element.bssid} RSSI: ${element.rssi} Frequency: ${element.frequency}");
    });
  }

  void clearLocalDataBase(){
    wifiDao.deleteAll();
  }
}