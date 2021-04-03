import 'dart:async';

import 'package:wifi/wifi.dart';
import 'package:wifi_scanning_flutter/screens/demo/db_operations.dart';
import 'package:wifi_scanning_flutter/screens/demo/widgets/wifi_matching.dart';
import 'package:wifi_scanning_flutter/services/user_preference.dart';

class WiFiBackgroundActivityManager {
  DatabaseOperations databaseOperations = DatabaseOperations();
  WifiMatching matcher = new WifiMatching();
  Function refresh;
  Timer timer;

  //WiFi matching parameters
  String userId;
  double filterPercentage = 0.5;
  double similarityThreshold = 0.0;
  Duration matchInterval = Duration(seconds: 5);

  //Singleton instance
  static final WiFiBackgroundActivityManager _singleton = WiFiBackgroundActivityManager._();
  // A private constructor which allows us to create instances of WiFiBackgroundActivityManager
  // only from within the WiFiBackgroundActivityManager itself.
  WiFiBackgroundActivityManager._();
  //pass the refresh function into the constructor
  factory WiFiBackgroundActivityManager(String userId, Function refreshMainPage){
    _singleton.refresh = refreshMainPage;
    _singleton.userId = userId;
    return _singleton;
  }

  Future<void> startTimer() async {
    //Since the timer function will not run immediately, findMatch needs to be called explicitly
    //await findMatch();
    if(timer == null) {
      timer = Timer.periodic(matchInterval, (timer) async {
        Stopwatch stopwatch = new Stopwatch()..start();
        //print("Scanning...");
        await findMatch();
        int totalMatchingTimes = UserPreference.getMatchingTimes();
        if(totalMatchingTimes >= 3){
          //the isolation due only needs to be set once
          if(totalMatchingTimes == 3 && UserPreference.getIsolationDue() == ""){
            await UserPreference.setIsolationDue(DateTime.now().add(Duration(days: 10)).toString());
            //print("Isolation Due is set");
          }
          //When the user has 3 or more consecutive matching, the contacted state is set to true
          await UserPreference.setContactedState(true);
        }
        else{
          await UserPreference.setContactedState(false);
        }
        refresh();
        print('The timer executed in ${stopwatch.elapsed}');
      });
    }
  }

  void cancelTimer() {
    if (timer != null) {
      timer.cancel();
      //Need to manually set the timer object to null because even when the timer is cancelled,
      //there is still a timer object; hence new timer cannot be scheduled.
      //Since timer is possibly null when cancel is called, if statement is needed to check
      timer = null;
    }
  }
  
  int tmp = 0;
  Future<void> findMatch() async {
    List<WifiResult> wifiScans = await databaseOperations.scanWifi();
    databaseOperations.storeScansInLocalDatabase(wifiScans);
    bool hasMatch = await matcher.matchFingerprints(userId, matchInterval, filterPercentage, similarityThreshold);
    if(hasMatch) {
      int totalMatchingTime = UserPreference.getMatchingTimes() + 1;
      await UserPreference.setMatchingTimes(totalMatchingTime);
      print("Total number of contact matching: " + totalMatchingTime.toString());
    }
    //Only clear the total matching time (when there aren't consecutive matching) for a user who hasn't been contacted
    //Otherwise, it might accidentally remove the isolation countdown for the user who has been contacted 
    else if (!hasMatch && !UserPreference.getContactedState()){
      await UserPreference.setMatchingTimes(0);
      tmp += 1;
      print(tmp.toString());
      //print("Total number of contact matching is set to 0");
    }
  }
}