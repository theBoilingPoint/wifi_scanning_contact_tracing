import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi/wifi.dart';

import 'background.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int level = 0;
  List<WifiResult> ssidList = [];
  String ssid = '', password = '';

  @override
  void initState() {
    super.initState();
    // _userData.initialiseDatabse().then((value) {
    //   print("Database is initialised");
    // });
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
                main();
                // Navigator.push(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (context) => BackgroundTask()));
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
          ssidList.forEach((element) => print(
              "SSID: " + element.ssid + " RSSI: " + element.level.toString()));
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
}
