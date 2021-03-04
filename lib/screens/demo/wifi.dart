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

  double strongestNPercentInRssi = 0;
  double similarityThr = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);
    final Color kingsBlue = HexColor('#0a2d50');
    final Color kingsPearlGrey = HexColor("cdd7dc");

    return Scaffold(
        appBar: AppBar(
          title: Text("WiFi List"),
          centerTitle: true,
          backgroundColor: kingsBlue,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (val) async {
                switch (val) {
                  case TextMenu.scan:
                    await loadData();
                    break;
                  case TextMenu.store:
                    await storeScansInLocalDatabase();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Scans have been saved locally."),
                        ));
                    printWiFiListInLocalDatabase();
                    break;
                  case TextMenu.upload:
                    await uploadScansToCloud(user.uid);
                    break;
                  case TextMenu.match:
                    await createParameterAdjustingDialog(context);
                    break;
                  case TextMenu.clear:
                    clearLocalDataBase();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All scans stored locally have been deleted."),
                        ));
                    break;
                }
              },
              itemBuilder: (context) => TextMenu.items.map((e) => PopupMenuItem(
                  value: e,
                  child: Text(e))
              ).toList(),
            )
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
      );
  }

  Function listCompare = const ListEquality().equals;

  Future<void> loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
      });
    });
  }

  Future<void> storeScansInLocalDatabase() async {
    String timeStamp = DateTime.now().toString();
    for(var i = 0; i < ssidList.length; i++){
      CustomisedWifi curWifi = new CustomisedWifi(timeStamp, ssidList[i].ssid, ssidList[i].bssid, ssidList[i].level, ssidList[i].frequency);
      await wifiDao.insert(curWifi);
    }
  }

  Future<void> uploadScansToCloud(String userId) async {
    List<CustomisedWifi> wifiListInDatabase = await wifiDao.getAllSortedBy("dateTime");
    Map<String, List<CustomisedWifi>> groupedwifiList = groupBy(wifiListInDatabase, (CustomisedWifi eachSignal) => eachSignal.dateTime);
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

  void printWiFiListInLocalDatabase() async {
    List wifiListInDatabase = await wifiDao.getAllSortedBy("dateTime");
    wifiListInDatabase.forEach((element) {
      print("Time: ${element.dateTime} SSID: ${element.ssid} BSSID: ${element.bssid} RSSI: ${element.rssi} Frequency: ${element.frequency}");
    });
  }

  void clearLocalDataBase(){
    wifiDao.deleteAll();
  }

  createParameterAdjustingDialog(BuildContext context){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Please adjust the matching parameters"),
        content: Column(
            children: <Widget> [
              Text("Filter Percentage"),
            Slider(
                label: strongestNPercentInRssi.toString(),
              value: strongestNPercentInRssi,
              min: 0,
              max: 1,
              onChanged: (double val) {
                print(val.toString());
                setState(() {
                  strongestNPercentInRssi = val;
                });
            }),
          Text("Similarity Threshold"),
          Slider(
              label: similarityThr.toString(),
              value: similarityThr,
              min: 0,
              max: 1,
              onChanged: (double val) {
                print(val.toString());
                setState(() {
                  similarityThr = val;
                });
              }),
            ]),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                },
              child: Text("OK"))
        ],
      );
    });
  }
}

class TextMenu {
  static const String scan = "Scan WiFi Signals";
  static const String store = "Store Current List";
  static const String upload = "Upload Current List";
  static const String match = "Find Match in Cloud";
  static const String clear = "Clear Local Database";

  static const items = <String>[
    scan,
    store,
    match,
    clear,
  ];
}

class WifiMatching {
  WifiDao wifiDao = WifiDao();
  /*
  * @param timeSpan is the of type Duration
  */
  Future<bool> matchFingerprints(String uid, Duration timeSpan, double filterPercentage, double similarityThreshold) async {
    //Get raw data from cloud and local dbs
    List<CustomisedWifi> rawLocalWifiList = await wifiDao.getAllSortedBy("dateTime");
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
}