import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tuple/tuple.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_scanning_flutter/models/customised_result.dart';
import 'package:wifi_scanning_flutter/models/customised_wifi.dart';
import 'package:wifi_scanning_flutter/screens/demo/db_operations.dart';
import 'package:wifi_scanning_flutter/screens/demo/widgets/dialogs.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi_matching.dart';

import 'step_card.dart';

class CardsCreator {
  //2 methods to interact with parent widgets
  //changeUserState is to change the Provider user state of WiFiScanPage
  //refreshMainPage is for refreshing the main page once got the matching algorithm result
  final Function changeUserState;
  final Function refreshMainPage;
  CardsCreator(this.changeUserState, this.refreshMainPage);
  final Color kingsBlue = HexColor('#0a2d50');

  DatabaseOperations databaseOperations = DatabaseOperations();
  DialogsCreator dialogsCreator = DialogsCreator();
  WifiMatching matcher = new WifiMatching();

  List<WifiResult> ssidList = [];
  List<CustomisedWifi> localDb = [];
  List<CustomisedResult> resultDb = [];

  double strongestNPercentInRssi = 0;
  double similarityThr = 0;
  bool hasMatch = false;
  double similarity = 0;

  List<Widget> createOnlineStepCards(BuildContext context, String userId) {
    List<StepCard> stepCards = [
      StepCard(
        stepNum: 1,
        description: "Download other users' scans from the cloud",
        buttons: [],
      ),
      StepCard(
        stepNum: 2,
        description:
            """For each scan in the local database, see if there is a scan from the cloud that is made within 15 minutes. Get 2 sets of matching, 1 for local and 1 for cloud.""",
        buttons: [],
      ),
      StepCard(
        stepNum: 3,
        description:
            """Group items in each set by timestamps and obtain 2 maps. Loop through entries of each map and return true if the similarity between 2 lists of scans within the same timestamp is above the threshold.""",
        buttons: [
          ElevatedButton(
            child: Text("Set Parameters"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () async {
              Tuple2<double, double> params =
                  await dialogsCreator.createParameterAdjustingDialog(context);
              strongestNPercentInRssi = params.item1;
              similarityThr = params.item2;
            },
          ),
          ElevatedButton(
            child: Text("Run the Algorithm"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () async {
              hasMatch = await matcher.matchFingerprints(
                  userId,
                  Duration(minutes: 15),
                  strongestNPercentInRssi,
                  similarityThr);
              similarity = matcher.similarity;
              await dialogsCreator.createResultConfirmingDialog(context,
                  hasMatch, strongestNPercentInRssi, similarityThr, similarity);
              await changeUserState(hasMatch);
              refreshMainPage();
            },
          ),
          ElevatedButton(
            child: Text("View Result Database"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () async {
              resultDb = await databaseOperations.getResultDbBy("similarity");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text(
                                "Result Database",
                                style: TextStyle(
                                    fontFamily: "MontserratRegular",
                                    fontWeight: FontWeight.w600),
                              ),
                              centerTitle: true,
                              backgroundColor: kingsBlue,
                            ),
                            body: InteractiveViewer(
                              constrained: false,
                              child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('similarity')),
                                    DataColumn(
                                        label: Text('similarityThreshold')),
                                    DataColumn(label: Text('filterPercentage')),
                                    DataColumn(label: Text('prediction')),
                                    DataColumn(label: Text('truth')),
                                  ],
                                  rows: resultDb
                                      .map((e) => DataRow(cells: [
                                            DataCell(
                                                Text(e.similarity.toString())),
                                            DataCell(Text(e.similarityThreshold
                                                .toString())),
                                            DataCell(Text(
                                                e.filterPercentage.toString())),
                                            DataCell(
                                                Text(e.prediction.toString())),
                                            DataCell(Text(e.truth.toString())),
                                          ]))
                                      .toList()),
                            ),
                          )));
            },
          ),
          ElevatedButton(
            child: Text("Clear Result Database"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () {},
            onLongPress: () {
              databaseOperations.clearResultDatabase();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Result database is cleared."),
              ));
            },
          ),
        ],
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
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () async {
              ssidList = await databaseOperations.scanWifi();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Scan finished."),
              ));
            },
          ),
          ElevatedButton(
            child: Text("View Current Scan"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text(
                                "Current Scan",
                                style: TextStyle(
                                    fontFamily: "MontserratRegular",
                                    fontWeight: FontWeight.w600),
                              ),
                              centerTitle: true,
                              backgroundColor: kingsBlue,
                            ),
                            body: InteractiveViewer(
                              constrained: false,
                              child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('SSID')),
                                    DataColumn(label: Text('BSSID')),
                                    DataColumn(label: Text('RSSI')),
                                    DataColumn(label: Text('Frequency')),
                                  ],
                                  rows: ssidList
                                      .map((e) => DataRow(cells: [
                                            DataCell(Text(e.ssid)),
                                            DataCell(Text(e.bssid)),
                                            DataCell(Text(e.level.toString())),
                                            DataCell(
                                                Text(e.frequency.toString())),
                                          ]))
                                      .toList()),
                            ),
                          )));
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
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () {
              databaseOperations.storeScansInLocalDatabase(ssidList);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Current scan is stored."),
              ));
            },
          ),
          ElevatedButton(
            child: Text("View Local Database"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () async {
              localDb = await databaseOperations.getLocalDbBy("dateTime");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text(
                                "Local Database",
                                style: TextStyle(
                                    fontFamily: "MontserratRegular",
                                    fontWeight: FontWeight.w600),
                              ),
                              centerTitle: true,
                              backgroundColor: kingsBlue,
                            ),
                            body: InteractiveViewer(
                              constrained: false,
                              child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('dateTime')),
                                    DataColumn(label: Text('BSSID')),
                                    DataColumn(label: Text('RSSI')),
                                  ],
                                  rows: localDb
                                      .map((e) => DataRow(cells: [
                                            DataCell(Text(e.dateTime)),
                                            DataCell(Text(e.bssid)),
                                            DataCell(Text(e.rssi.toString())),
                                          ]))
                                      .toList()),
                            ),
                          )));
            },
          ),
          ElevatedButton(
            child: Text("Clear Local Database"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () {
              //print("Please long press this button to make it work");
            },
            onLongPress: () {
              databaseOperations.clearLocalDatabase();
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
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () {
              databaseOperations.uploadScansToCloud(userId);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Current local database has been uploaded."),
              ));
            },
          ),
          ElevatedButton(
            child: Text("Clear Current User's Cloud Data"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
            onPressed: () {},
            onLongPress: () {
              databaseOperations.clearCloudDatabase(userId);
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
