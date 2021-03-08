import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/data/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi.dart';
import 'package:wifi_scanning_flutter/screens/user/common_questions.dart';
import 'package:wifi_scanning_flutter/screens/user/symptom.dart';
import 'package:wifi_scanning_flutter/screens/user/webpageManager.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/contact_widget.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/healthy_widget.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/infected_widget.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/symptoms_widget.dart';
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
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);

    Future<void> checkInfectionData() async {
      if (user.infectionState) {
        storeScansWithin7DaysInCloudDatabase(user.uid);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Scans within 7 days have been uploaded to cloud."),
        ));
      } else {
        await DatabaseService(uid: user.uid).deleteAllScansOfCurrentUser();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Scans in the cloud have been deleted."),
        ));
      }
    }

    void toggleInfectionState() {
      setState(() {
        user.infectionState = !user.infectionState;
      });
      checkInfectionData();
    }

    Widget mainWidget = getMainPage(context, user);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
              fontFamily: "MontserratRegular", fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: kingsBlue,
      ),
      drawer: Drawer(
        child: Container(
          alignment: Alignment.center,
          child: ListView(
              padding: EdgeInsets.only(top: 50),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(CupertinoIcons.wifi),
                  title: Text(
                    "Scan WiFi",
                    style:
                        TextStyle(fontFamily: "MontserratBold", fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => WifiScanPage(
                                  notifyParent: refresh,
                                )));
                  },
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.checkmark_rectangle),
                  title: Text(
                    "Check Symptoms",
                    style:
                        TextStyle(fontFamily: "MontserratBold", fontSize: 20),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new SymptomsCheckPage(
                                  notifyParent: refresh,
                                )));
                  },
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.chart_bar_alt_fill),
                  title: Text(
                    "Check Local Tier",
                    style:
                        TextStyle(fontFamily: "MontserratBold", fontSize: 20),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => WebpageManager(
                                  pageName: "tier",
                                )));
                  },
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.map_pin_ellipse),
                  title: Text(
                    "Check Heatmap",
                    style:
                        TextStyle(fontFamily: "MontserratBold", fontSize: 20),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => WebpageManager(
                                  pageName: "heatmap",
                                )));
                  },
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.question_circle),
                  title: Text(
                    "Common Questions",
                    style:
                        TextStyle(fontFamily: "MontserratBold", fontSize: 20),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => CommonQuestionsPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Logout",
                    style:
                        TextStyle(fontFamily: "MontserratBold", fontSize: 20),
                  ),
                  onTap: () async {
                    await _auth.signOut();
                    //Go back to sign in page by removing the top elements of the page stack
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  },
                ),
              ]),
        ),
      ),
      body: Center(
        child: mainWidget,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.priority_high),
        backgroundColor: kingsBlue,
        label: Text("Toggle Infection State"),
        onPressed: () {
          toggleInfectionState();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void refresh() {
    setState(() {});
  }

  InfectedWidgetLayout infectedWidgetLayout = InfectedWidgetLayout();
  SymptomsWidgetLayout symptomsWidgetLayout = SymptomsWidgetLayout();
  HealthyWidgetLayout healthyWidgetLayout = HealthyWidgetLayout();
  ContactWidgetLayout contactWidgetLayout = ContactWidgetLayout();

  Widget getMainPage(BuildContext context, CustomisedUser curUser) {
    if (curUser.infectionState) {
      return infectedWidgetLayout.getWidgetWhenInfected(context);
    } else if (curUser.gotTemperature ||
        curUser.gotCough ||
        curUser.gotSenseLoss) {
      return symptomsWidgetLayout.getWidgetWhenGotSymptoms(context);
    } else if (curUser.hasBeenContacted) {
      return contactWidgetLayout.getWidgetWhenContacted(context);
    } else {
      return healthyWidgetLayout.getWidgetWhenHealthy(context);
    }
  }

  WifiDao wifiDao = WifiDao();

  Future<void> storeScansWithin7DaysInCloudDatabase(userId) async {
    List<CustomisedWifi> wifiListInDatabase =
        await wifiDao.getScansWithin7Days();
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
}
