import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanning_flutter/data/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';

import 'background.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key wifiList}): super(key: wifiList);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int level = 0;
  List<WifiResult> ssidList = [];
  String ssid = '', password = '';
  WifiDao wifiDao = WifiDao();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color kingsBlue = HexColor('#0a2d50');
    final Color kingsPearlGrey = HexColor("cdd7dc");

    return Scaffold(
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
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => main()));
              })
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: ssidList.length,
          itemBuilder: (BuildContext context, int index) {
            // return itemList(index);
            return ListTile(
                title: Text(
                    "SSID: ${ssidList[index].ssid}  RSSI: ${ssidList[index].level}"));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings_input_antenna),
        onPressed: () async {
          loadData();
          //storeWiFiListInLocalDatabase();
          //printWiFiListInLocalDatabase();
          //printWiFiList();
        },
      ),
    );
  }

  void loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
      });
    });
  }

  void storeWiFiListInLocalDatabase(){
    for(var i = 0; i < ssidList.length; i++){
      CustomisedWifi curWifi = new CustomisedWifi(DateTime.now().toString(), ssidList[i].ssid, ssidList[i].level);
      wifiDao.insert(curWifi);
    }
  }

  void printWiFiListInLocalDatabase() async {
    List wifiListInDatabase = await wifiDao.getAllSortedByTime();
    wifiListInDatabase.forEach((element) => print("Time: ${element.dateTime} SSID: ${element.ssid} RSSI: ${element.rssi}"));
  }

  void clearLocalDataBase(){
    wifiDao.deleteAll();
  }

  void printWiFiList() {
    ssidList.forEach((element) => print(
        "SSID: " + element.ssid + " RSSI: " + element.level.toString()));
  }
}
