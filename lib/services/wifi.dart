import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: ssidList.length,
          itemBuilder: (BuildContext context, int index) {
            // return itemList(index);
            return ListTile(
              title: Text("SSID: ${ssidList[index].ssid}  RSSI: ${ssidList[index].level}")
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings_input_antenna),
        onPressed: () async {
          loadData();
          ssidList.forEach((element) => print("SSID: " + element.ssid + " RSSI: " + element.level.toString()));
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