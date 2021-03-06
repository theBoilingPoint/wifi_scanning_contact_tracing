import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/screens/demo/db_operations.dart';
import 'package:wifi_scanning_flutter/screens/demo/widgets/cards.dart';
import 'package:wifi_scanning_flutter/screens/demo/widgets/dialogs.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi_matching.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key wifiList}) : super(key: wifiList);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WifiMatching matcher = new WifiMatching();
  DatabaseOperations databaseOperations = DatabaseOperations();

  DialogsCreator dialogsCreator = DialogsCreator();
  CardsCreator cardsCreator = CardsCreator();
  int bottomNavigationBarIdx = 0;

  bool hasMatch;
  double strongestNPercentInRssi = 0;
  double similarityThr = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      bottomNavigationBarIdx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);
    final Color kingsBlue = HexColor('#0a2d50');
    List<Widget> _widgetOptions =
        createBottomNavigatorBarWidgets(context, user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text("WiFi List"),
        centerTitle: true,
        backgroundColor: kingsBlue,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (val) async {
              switch (val) {
                case TextMenu.param:
                  Tuple2<double, double> params = await dialogsCreator
                      .createParameterAdjustingDialog(context);
                  strongestNPercentInRssi = params.item1;
                  similarityThr = params.item2;
                  break;
                case TextMenu.match:
                  setState(() async {
                    hasMatch = await matcher.matchFingerprints(
                        user.uid,
                        Duration(minutes: 15),
                        strongestNPercentInRssi,
                        similarityThr);
                    await dialogsCreator.createResultConfirmingDialog(context,
                        hasMatch, strongestNPercentInRssi, similarityThr);
                  });
                  break;
              }
            },
            itemBuilder: (context) => TextMenu.items
                .map((e) => PopupMenuItem(value: e, child: Text(e)))
                .toList(),
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(bottomNavigationBarIdx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.signal_wifi_4_bar_lock), label: "Offline Phase"),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload), label: "Online Phase"),
        ],
        currentIndex: bottomNavigationBarIdx,
        onTap: _onItemTapped,
      ),
    );
  }

  List<Widget> createBottomNavigatorBarWidgets(
      BuildContext context, String userId) {
    List<Widget> widgets = [
      Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.8,
              initialPage: 0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            ),
            items: cardsCreator.createOfflineStepCards(context, userId),
          ),
        ],
      )),
      Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.8,
              initialPage: 0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            ),
            items: cardsCreator.createOnlineStepCards(),
          ),
        ],
      )),
    ];
    return widgets;
  }
}

class TextMenu {
  static const String param = "Set Matching Parameters";
  static const String match = "Find Match in Cloud";
  static const String localDb = "View Local Database";
  static const String resultDb = "View Result Database";

  static const items = <String>[
    param,
    match,
    localDb,
    resultDb,
  ];
}
