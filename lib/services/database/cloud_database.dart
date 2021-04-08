import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wifi_scanning_flutter/services/user_preference.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';

class CloudDatabase {
  final String uid;
  //class constructor
  CloudDatabase({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(Map<String, List<Map>> curLst) async {
    return await userCollection
        .doc("$uid")
        .set(curLst)
        .whenComplete(() => print("Saving action complete"))
        .onError((error, stackTrace) => print("Failed to save the scan"));
  }

  Future<List<CustomisedWifi>> getAllScansFromCloudMadeByOtherUsers() async {
    List<CustomisedWifi> cloudList = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    snapshot.docs.forEach((element) {
      String curUid = element.id;
      //we only need to get other users' data
      if (curUid != uid) {
        element.data().forEach((key, value) {
          String timestamp = key;
          value.toList().forEach((signal) {
            cloudList.add(CustomisedWifi(timestamp, signal["ssid"],
                signal["bssid"], signal["rssi"], signal["frequency"]));
          });
        });
      }
    });

    return cloudList;
  }

  Future<void> deleteAllScansOfCurrentUser() async {
    await FirebaseFirestore.instance
    .collection("users").doc(UserPreference.getUsername()).delete();
  }
}
