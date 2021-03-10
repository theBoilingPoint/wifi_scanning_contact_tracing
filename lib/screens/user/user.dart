import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/data/user_preference.dart';
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
  CustomisedUser currentUser = CustomisedUser("");

  @override
  void initState() {
    super.initState();
    updateUserStates();
  }

  void refresh() {
    setState(() {
      updateUserStates();
    });
  }

  void updateUserStates() {
    currentUser.uid = UserPreference.getUsername();
    currentUser.infectionState = UserPreference.getInfectionState();
    currentUser.hasBeenContacted = UserPreference.getContactedState();
    currentUser.gotTemperature = UserPreference.getHasFever();
    currentUser.gotCough = UserPreference.getHasCough();
    currentUser.gotSenseLoss = UserPreference.getHasSenseLoss();
    currentUser.isolationUntil = UserPreference.getIsolationDue();
    print("id: ${currentUser.uid}");
    print("infection: ${currentUser.infectionState.toString()}");
    print("contacted: ${currentUser.hasBeenContacted.toString()}");
    print("fever: ${currentUser.gotTemperature.toString()}");
    print("cough: ${currentUser.gotCough.toString()}");
    print("sense loss: ${currentUser.gotSenseLoss.toString()}");
    print("isolation: ${currentUser.isolationUntil}");
    print("");
  }

  Future<void> clearSickStates() async {
      await UserPreference.setContactedState(false);
      await UserPreference.setInfectionState(false);
      await UserPreference.setHasFever(false);
      await UserPreference.setHasCough(false);
      await UserPreference.setHasSenseLoss(false);
      await UserPreference.setIsolationDue("");
  }

  @override
  Widget build(BuildContext context) {
    Future<void> checkInfectionData() async {
      if (currentUser.infectionState) {
        storeScansWithin7DaysInCloudDatabase();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Scans within 7 days have been uploaded to cloud."),
        ));
      } else {
        await DatabaseService(uid: currentUser.uid).deleteAllScansOfCurrentUser();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Scans in the cloud have been deleted."),
        ));
      }
    }

    Future<void> toggleInfectionState() async { 
      currentUser.infectionState = !currentUser.infectionState;
      //if the user if not infected after toggle, we need to set the isolation due
      //back to none and update the preference
      if(currentUser.infectionState == false){
        //The reason why we need to specifically set the all sick states back to none
        //is that once the user is tested negative then he won't have any issues any more
        await clearSickStates();
      }
      //else if the user if infected after toggle and he's not in an isolation yet
      //set the timer for 10 days
      else if(currentUser.infectionState && currentUser.isolationUntil == "") {
        currentUser.isolationUntil = DateTime.now().add(Duration(days: 10)).toString();
        await UserPreference.setIsolationDue(currentUser.isolationUntil);
      }
      await UserPreference.setInfectionState(currentUser.infectionState);
      checkInfectionData();
      refresh();
    }

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
              child: getMainPage(context),
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.priority_high),
        backgroundColor: kingsBlue,
        label: Text("Toggle Infection State"),
        onPressed: () async {
          await toggleInfectionState();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  InfectedWidgetLayout infectedWidgetLayout = InfectedWidgetLayout();
  SymptomsWidgetLayout symptomsWidgetLayout = SymptomsWidgetLayout();
  HealthyWidgetLayout healthyWidgetLayout = HealthyWidgetLayout();
  ContactWidgetLayout contactWidgetLayout = ContactWidgetLayout();

  Widget getMainPage(BuildContext context) {
    if (currentUser.infectionState) {
      return infectedWidgetLayout.getWidgetWhenInfected(context, getRemainingTime());
    } else if (currentUser.gotTemperature ||
        currentUser.gotCough ||
        currentUser.gotSenseLoss) {
      return symptomsWidgetLayout.getWidgetWhenGotSymptoms(context, getRemainingTime());
    } else if (currentUser.hasBeenContacted) {
      return contactWidgetLayout.getWidgetWhenContacted(context, getRemainingTime());
    } else {
      clearSickStates();
      return healthyWidgetLayout.getWidgetWhenHealthy(context);
    }
  }

  Duration getRemainingTime() {
    DateTime curTime = DateTime.now();
    String expectedDue = UserPreference.getIsolationDue();
    if(expectedDue != ""){
      DateTime dueTime = DateTime.parse(expectedDue);
      if(curTime.isBefore(dueTime)){
        return dueTime.difference(curTime);
      }
    }
    return Duration(seconds: 1);
  }

  WifiDao wifiDao = WifiDao();

  Future<void> storeScansWithin7DaysInCloudDatabase() async {
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

    await DatabaseService(uid: currentUser.uid).updateUserData(newGroupedWifiList);
  }
}

class MainPageManager {
  //final Function refresh;
  final Function clearStates;
  MainPageManager(this.clearStates);

  InfectedWidgetLayout infectedWidgetLayout = InfectedWidgetLayout();
  SymptomsWidgetLayout symptomsWidgetLayout = SymptomsWidgetLayout();
  HealthyWidgetLayout healthyWidgetLayout = HealthyWidgetLayout();
  ContactWidgetLayout contactWidgetLayout = ContactWidgetLayout();

  Widget getMainPage(BuildContext context) {
    if (UserPreference.getInfectionState()) {
      return infectedWidgetLayout.getWidgetWhenInfected(context, getRemainingTime());
    } else if (UserPreference.getHasFever() ||
        UserPreference.getHasCough() ||
        UserPreference.getHasSenseLoss()) {
      return symptomsWidgetLayout.getWidgetWhenGotSymptoms(context, getRemainingTime());
    } else if (UserPreference.getContactedState()) {
      return contactWidgetLayout.getWidgetWhenContacted(context, getRemainingTime());
    } else {
      clearStates();
      return healthyWidgetLayout.getWidgetWhenHealthy(context);
    }
  }

  Duration getRemainingTime() {
    DateTime curTime = DateTime.now();
    String expectedDue = UserPreference.getIsolationDue();
    if(expectedDue != ""){
      DateTime dueTime = DateTime.parse(expectedDue);
      if(curTime.isBefore(dueTime)){
        return dueTime.difference(curTime);
      }
    }
    return Duration(seconds: 1);
  }
}
