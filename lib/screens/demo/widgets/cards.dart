import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanning_flutter/screens/demo/db_operations.dart';

import 'step_card.dart';

class CardsCreator {
  DatabaseOperations databaseOperations = DatabaseOperations();
  List<WifiResult> ssidList = [];

  List<Widget> createOnlineStepCards() {
    List<StepCard> stepCards = [
      StepCard(
        stepNum: 1,
        description: "Download other users' scans from the cloud",
        buttons: [],
      ),
      StepCard(
        stepNum: 2,
        description: """For each scan in the local database, see if there is a scan from the cloud that is made within 15 minutes. Get 2 sets of matching, 1 for local and 1 for cloud.""",
        buttons: [],
      ),
      StepCard(
        stepNum: 3,
        description: """Group items in each set by timestamps and obtain 2 maps. Loop through entries of each map and return true if the similarity between 2 lists of scans within the same timestamp is above the threshold.""",
        buttons: [],
      )
    ];
    return stepCards;
  }

  List<Widget> createOfflineStepCards(BuildContext context, String userId) {
    List<StepCard> stepCards = [
      StepCard(
        stepNum: 1,
        description: "Scan wifi signals for 3 times per 15 minutes.",
        buttons: [
          ElevatedButton(
            child: Text("Scan Wifi"),
            onPressed: () async {
              ssidList = await databaseOperations.scanWifi();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Scan finished."),
              ));
            },
          ),
          ElevatedButton(
            child: Text("View Current Scan"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: ssidList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (ssidList.isEmpty) {
                              return Column(
                                  //TODO need to figure out a display for empty scan!
                                  );
                            } else {
                              return Material(
                                child: ListTile(
                                    title: Text(
                                        "BSSID: ${ssidList[index].bssid} RSSI: ${ssidList[index].level}dBm Frequency: ${ssidList[index].frequency}MHz")),
                              );
                            }
                          })));
            },
          ),
        ],
      ),
      StepCard(
        stepNum: 2,
        description: "Store each scan in the local database",
        buttons: [
          ElevatedButton(
            child: Text("Store Current Scan"),
            onPressed: () {
              databaseOperations.storeScansInLocalDatabase(ssidList);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Current scan is stored."),
              ));
            },
          ),
          ElevatedButton(
            child: Text("Clear Local Database"),
            onPressed: () {},
            onLongPress: () {
              databaseOperations.clearLocalDataBase();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Local database is cleared."),
              ));
            },
          ),
        ],
      ),
      StepCard(
        stepNum: 3,
        description:
            "Once the user is tested postive, the scans in the local database within 7 days will be uploaded to the cloud database.",
        buttons: [
          ElevatedButton(
            child: Text("Upload to Cloud"),
            onPressed: () {
              databaseOperations.uploadScansToCloud(userId);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Current local database has been uploaded."),
              ));
            },
          ),
          ElevatedButton(
            child: Text("Clear Current User's Cloud Data"),
            onPressed: () {},
            onLongPress: () {
              databaseOperations.clearCloudDataBase(userId);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Current cloud database has been cleared."),
              ));
            },
          ),
        ],
      ),
    ];
    return stepCards;
  }
}
