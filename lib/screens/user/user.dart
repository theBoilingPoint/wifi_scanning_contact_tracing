///This is the home/main page of the app
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi_algorithm_page.dart';
import 'package:wifi_scanning_flutter/screens/loading.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/symptoms_date_page.dart';
import 'package:wifi_scanning_flutter/screens/user/wifi_background_manager.dart';
import 'package:wifi_scanning_flutter/services/user_preference.dart';
import 'package:wifi_scanning_flutter/services/database/wifi_dao.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/common_questions.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/symptom.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/webpageManager.dart';
import 'package:wifi_scanning_flutter/screens/user/contact_widget.dart';
import 'package:wifi_scanning_flutter/screens/user/healthy_widget.dart';
import 'package:wifi_scanning_flutter/screens/user/infected_widget.dart';
import 'package:wifi_scanning_flutter/screens/user/symptoms_widget.dart';
import 'package:wifi_scanning_flutter/services/auth.dart';
import 'package:wifi_scanning_flutter/services/database/cloud_database.dart';

class User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserHomePage();
  }
}

class UserHomePage extends State<User> {
  final Color kingsBlue = HexColor('#0a2d50');
  final AuthService _auth = AuthService();
  WifiDao wifiDao = WifiDao();
  //WiFi background activity manager singleton instance
  WiFiBackgroundActivityManager wiFiBackgroundActivityManager;
  bool isScanning;
  String userId = UserPreference.getUsername();

  @override
  void initState() {
    super.initState();
    wiFiBackgroundActivityManager = WiFiBackgroundActivityManager(userId, refresh);
    initialiseWiFiBackgroundTimer();
  }

  Future<void> initialiseWiFiBackgroundTimer() async {
    isScanning = UserPreference.getWiFiBackgroundActivityState();
    if (isScanning) {
      await wiFiBackgroundActivityManager.startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    "WiFi Tracing",
                    style:
                        TextStyle(fontFamily: "MontserratBold", fontSize: 20),
                  ),
                  onTap: () {
                    isScanning = UserPreference.getWiFiBackgroundActivityState();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => WiFiBackgroundActivity(
                              notifyParent: refresh, 
                              isScanning: isScanning,
                              wiFiBackgroundActivityManager: wiFiBackgroundActivityManager
                        )
                      )
                    );
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
                    //if the user has any symptoms, lead to the symptoms page
                    //else lead to the date checker page
                    if(UserPreference.getHasFever() || 
                    UserPreference.getHasCough() || 
                    UserPreference.getHasSenseLoss()){
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new SymptomsCheckPage(
                              notifyParent: refresh,
                            )
                        )
                      );
                    }
                    else {
                       Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => SymptomsDatePicker(notifyParent: refresh,)
                        )
                      );
                    }
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
                    "Check Heat Map",
                    style:
                        TextStyle(fontFamily: "MontserratBold", fontSize: 20),
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => WebpageManager(
                          pageName: "heatmap",
                        )
                      )  
                    );
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
                        builder: (context) => CommonQuestionsPage()
                      )
                    );
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
                    wiFiBackgroundActivityManager.cancelTimer();
                    //if an account signs out, all data attached to this account should be 
                    //deleted or reset
                    await wifiDao.deleteAll();
                    await clearSickStates();
                    await UserPreference.setMatchingTimes(0);
                    await _auth.signOut();
                    //Go back to sign in page by removing the top elements of the page stack
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  },
                ),
              ]
            ),
        ),
      ),
      body: FutureBuilder(
        future: MainPageManager(context, refresh, clearSickStates).getMainPage(),
        builder: (context, AsyncSnapshot<Widget> snapshot){
          if(snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: snapshot.data,
            );
          }
          else {
            return LoadingPage();
          }
        },
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

  void refresh() {
    setState(() {});
  }

  Future<void> clearSickStates() async {
    //the matching times in UserPreference is not included as 
    //the user's sick state because it is independent
    //of the user and should be handled in the background activity
    await UserPreference.setContactedState(false);
    await UserPreference.setInfectionState(false);
    await UserPreference.setHasFever(false);
    await UserPreference.setHasCough(false);
    await UserPreference.setHasSenseLoss(false);
    await UserPreference.setIsolationDue("");
  }

  Future<void> toggleInfectionState() async {
    await UserPreference.setInfectionState(!UserPreference.getInfectionState());
    //if the user if not infected after toggle, we need to set the isolation due
    //back to none and update the preference
    if (UserPreference.getInfectionState() == false) {
      //The reason why we need to specifically set the all sick states back to none
      //is that once the user is tested negative then he won't have any issues any more
      await clearSickStates();
      //When the user is healthy, he/she is facing the risk of being contacted again.
      //Hence the matching algorithm fields need to be set back to default.
      await UserPreference.setMatchingTimes(0);
    }
    //else if the user if infected after toggle and he's not in an isolation yet
    //set the timer for 10 days
    else if (UserPreference.getInfectionState() &&
        UserPreference.getIsolationDue() == "") {
      await UserPreference.setIsolationDue(
          DateTime.now().add(Duration(days: 10)).toString());
    }
    handleCloudInfectionData();
    refresh();
  }

  Future<void> handleCloudInfectionData() async {
    if (UserPreference.getInfectionState()) {
      storeScansWithin14DaysInCloudDatabase();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Scans within 14 days have been uploaded to cloud."),
      ));
    } else {
      await CloudDatabase(uid: UserPreference.getUsername())
          .deleteAllScansOfCurrentUser();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Scans in the cloud have been deleted."),
      ));
    }
  }

  Future<void> storeScansWithin14DaysInCloudDatabase() async {
    List<CustomisedWifi> wifiListInDatabase =
        await wifiDao.getScansWithin14Days();
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

    await CloudDatabase(uid: UserPreference.getUsername())
        .updateUserData(newGroupedWifiList);
  }
}

///This class decides which widget should be rendered based on 
///user states in User Preference
class MainPageManager {
  BuildContext context;
  Function refresh;
  Function resetUserState;
  MainPageManager(this.context, this.refresh, this.resetUserState);

  Future<Widget> getMainPage() async {
    Duration remainingIsolationTime = getRemainingTime();

    if(remainingIsolationTime != Duration.zero){
      if (UserPreference.getInfectionState()) {
        return InfectedWidgetLayout(refresh)
          .getWidgetWhenInfected(context, remainingIsolationTime);
      } 
      else if (UserPreference.getHasFever() ||
        UserPreference.getHasCough() ||
        UserPreference.getHasSenseLoss()) {
        return SymptomsWidgetLayout(this.refresh)
          .getWidgetWhenGotSymptoms(context, remainingIsolationTime);
    } 
      else if (UserPreference.getContactedState()) {
        return ContactWidgetLayout(this.refresh)
          .getWidgetWhenContacted(context, remainingIsolationTime);
      } 
    }
    //when the countdown is over, the user state should be cleared
    resetUserState();
    return HealthyWidgetLayout().getWidgetWhenHealthy(context);
  }

  //get the remaining time for the countdown display
  Duration getRemainingTime() {
    DateTime curTime = DateTime.now();
    String expectedDue = UserPreference.getIsolationDue();
    if (expectedDue != "") {
      DateTime dueTime = DateTime.parse(expectedDue);
      if (curTime.isBefore(dueTime)) {
        return dueTime.difference(curTime);
      }
    }
    //if when user gets back to the app, it's gone pass
    //the isolation due date
    return Duration.zero;
  }
}
