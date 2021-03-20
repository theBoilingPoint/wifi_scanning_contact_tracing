import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/screens/loading.dart';
import 'package:wifi_scanning_flutter/services/user_preference.dart';
import 'package:wifi_scanning_flutter/services/database/wifi_dao.dart';
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

  @override
  void initState() {
    super.initState();
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
    await UserPreference.setContactedState(false);
    await UserPreference.setInfectionState(false);
    await UserPreference.setHasFever(false);
    await UserPreference.setHasCough(false);
    await UserPreference.setHasSenseLoss(false);
    await UserPreference.setIsolationDue("");
  }

  Future<void> checkInfectionData() async {
    if (UserPreference.getInfectionState()) {
      storeScansWithin7DaysInCloudDatabase();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Scans within 7 days have been uploaded to cloud."),
      ));
    } else {
      await DatabaseService(uid: UserPreference.getUsername())
          .deleteAllScansOfCurrentUser();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Scans in the cloud have been deleted."),
      ));
    }
  }

  Future<void> toggleInfectionState() async {
    await UserPreference.setInfectionState(!UserPreference.getInfectionState());
    //if the user if not infected after toggle, we need to set the isolation due
    //back to none and update the preference
    if (UserPreference.getInfectionState() == false) {
      //The reason why we need to specifically set the all sick states back to none
      //is that once the user is tested negative then he won't have any issues any more
      await clearSickStates();
    }
    //else if the user if infected after toggle and he's not in an isolation yet
    //set the timer for 10 days
    else if (UserPreference.getInfectionState() &&
        UserPreference.getIsolationDue() == "") {
      await UserPreference.setIsolationDue(
          DateTime.now().add(Duration(days: 10)).toString());
    }

    checkInfectionData();
    refresh();
  }

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

    await DatabaseService(uid: UserPreference.getUsername())
        .updateUserData(newGroupedWifiList);
  }
}

class MainPageManager {
  BuildContext context;
  Function refresh;
  Function resetUserStates;
  MainPageManager(this.context, this.refresh, this.resetUserStates);

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
    else {
      await resetUserStates();
    }
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
