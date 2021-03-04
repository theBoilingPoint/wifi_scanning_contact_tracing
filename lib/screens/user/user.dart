import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/data/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi.dart';
import 'package:wifi_scanning_flutter/screens/webpage//heatmap_webpage.dart';
import 'package:wifi_scanning_flutter/screens/webpage/testbooking_webpage.dart';
import 'package:wifi_scanning_flutter/services/auth.dart';
import 'package:wifi_scanning_flutter/services/cloud_database.dart';

class User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserHomePage();
  }
}

class UserHomePage extends State<User> {
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPearlGrey = HexColor("cdd7dc");
  final AuthService _auth = AuthService();

  @override
  void initState(){
   super.initState();
  }

  @override
  Widget build(BuildContext context){
    final user = Provider.of<CustomisedUser>(context);

    Future<void> checkInfectionData() async {
      if(user.infectionState) {
        storeScansWithin7DaysInCloudDatabase(user.uid);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Scans within 7 days have been uploaded to cloud."),
            ));
      }
      else{
        await DatabaseService(uid: user.uid).deleteAllScansOfCurrentUser();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Scans in the cloud have been deleted."),
            ));
      }
    }

    void toggleInfectionState(){
      setState(() {
        user.infectionState = !user.infectionState;
      });
      checkInfectionData();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Personal Page"),
          centerTitle: true,
          backgroundColor: kingsBlue,
        ),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.only(top: 70),
            children: <Widget>[
              TextButton(
                child: Text("Scan WiFi"),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              ),
              TextButton(
                child: Text("Check Heatmap"),
                onPressed: () async {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => HeatMapWebView()));
                },
              ),
              TextButton(
                child: Text("Book a Test"),
                onPressed: () async {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => TestBookingWebView()));
                },
              ),
              TextButton(
                child: Text("Logout"),
                onPressed: () async {
                  await _auth.signOut();
                  //Go back to sign in page by removing the top elements of the page stack
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                },
              ),
          ]),
      ),
      body: Center(
        child: Text('The current user infection state is: ${user.infectionState}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.priority_high),
        onPressed: () {
          toggleInfectionState();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  WifiDao wifiDao = WifiDao();

  Future<void> storeScansWithin7DaysInCloudDatabase(userId) async {
    List<CustomisedWifi> wifiListInDatabase = await wifiDao.getScansWithin7Days();
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
}