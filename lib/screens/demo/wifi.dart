import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanning_flutter/data/result_dao.dart';
import 'package:wifi_scanning_flutter/data/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_result.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi_matching.dart';
import 'package:wifi_scanning_flutter/services/cloud_database.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key wifiList}) : super(key: wifiList);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int level = 0;
  List<WifiResult> ssidList = [];
  WifiDao wifiDao = WifiDao();
  ResultDao resultDao = ResultDao();
  WifiMatching matcher = new WifiMatching();

  bool hasMatch;
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Scans have been saved locally."),
                  ));
                  printWiFiListInLocalDatabase();
                  break;
                case TextMenu.upload:
                  await uploadScansToCloud(user.uid);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Scans have been uploaded to cloud."),
                  ));
                  break;
                case TextMenu.param:
                  await createParameterAdjustingDialog(context);
                  break;
                case TextMenu.match:
                  setState(() async {
                    hasMatch = await matcher.matchFingerprints(
                        user.uid,
                        Duration(minutes: 15),
                        strongestNPercentInRssi,
                        similarityThr);
                    await createResultConfirmingDialog(context);
                  });
                  break;
              }
            },
            itemBuilder: (context) => TextMenu.items
                .map((e) => PopupMenuItem(value: e, child: Text(e)))
                .toList(),
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

  Future<void> createResultConfirmingDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Result"),
            content: Text("The predicted matching result is: $hasMatch"),
            actions: [
              TextButton(
                  onPressed: () async {
                    await resultDao.insert(new CustomisedResult(
                        strongestNPercentInRssi,
                        similarityThr,
                        hasMatch,
                        true));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This result has been saved."),
                    ));
                    Navigator.of(context).pop();
                  },
                  child: Text("Correct")),
              TextButton(
                  onPressed: () async {
                    await resultDao.insert(new CustomisedResult(
                        strongestNPercentInRssi,
                        similarityThr,
                        hasMatch,
                        false));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This result has been saved."),
                    ));
                    Navigator.of(context).pop();
                  },
                  child: Text("Wrong")),
            ],
          );
        });
  }

  Future<void> createParameterAdjustingDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          double newStrongestNPercentInRssi = 0;
          double newSimilarityThr = 0;
          //need to wrap the dialog inside a stateful widget otherwise
          //the sliders don't slide
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Please adjust the matching parameters"),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Filter Percentage: ${strongestNPercentInRssi.toStringAsFixed(2)}"),
                Slider(
                    value: strongestNPercentInRssi,
                    min: 0,
                    max: 1,
                    onChanged: (double val) {
                      //print(val.toString());
                      setState(() {
                        newStrongestNPercentInRssi = val;
                        strongestNPercentInRssi = newStrongestNPercentInRssi;
                      });
                    }),
                Text(
                    "Similarity Threshold: ${similarityThr.toStringAsFixed(2)}"),
                Slider(
                    value: similarityThr,
                    min: 0,
                    max: 1,
                    onChanged: (double val) {
                      //print(val.toString());
                      setState(() {
                        newSimilarityThr = val;
                        similarityThr = newSimilarityThr;
                      });
                    }),
              ]),
            );
          });
        });
  }
}

class TextMenu {
  static const String scan = "Scan WiFi Signals";
  static const String store = "Store Current List";
  static const String upload = "Upload Current List";
  static const String param = "Set Matching Parameters";
  static const String match = "Find Match in Cloud";
  static const String clear = "Clear Local Database";

  static const items = <String>[
    scan,
    store,
    upload,
    param,
    match,
    clear,
  ];
}
