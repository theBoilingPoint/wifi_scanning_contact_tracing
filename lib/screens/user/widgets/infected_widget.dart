import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_scanning_flutter/data/user_preference.dart';
import 'package:wifi_scanning_flutter/screens/user/webpageManager.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class InfectedWidgetLayout {
  final Color kingsBlue = HexColor('#0a2d50');
  // final Function refreshMainPage;
  // InfectedWidgetLayout(this.refreshMainPage);

  Widget getWidgetWhenInfected(BuildContext context, Duration isolationRemainingTime) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/lottie/covid19.json",
            height: 300,
          ),
          Text(
            "You have been infected",
            style: TextStyle(fontFamily: "MontserratRegular", fontSize: 30),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please self-isolate for",
            style: TextStyle(
                fontFamily: "MontserratRegular",
                fontStyle: FontStyle.italic,
                fontSize: 25),
          ),
          SlideCountdownClock(
            duration: isolationRemainingTime,
            slideDirection: SlideDirection.Down,
            separator: ":",
            textStyle: TextStyle(
              fontFamily: "MontserratRegular",
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            onDone: () async {
              await UserPreference.setInfectionState(false);
              //refresh();
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 70),
            shrinkWrap: true,
            children: [
            ElevatedButton(
            child: Text(
              "Book a Test",
              style: TextStyle(fontSize: 20),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kingsBlue),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => WebpageManager(
                            pageName: "booking",
                          )));
            },
          ),
          ElevatedButton(
            child: Text(
              "Get an Isolation Note",
              style: TextStyle(fontSize: 20),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kingsBlue),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => WebpageManager(
                            pageName: "isolation_note",
                          )));
            },
          ),
            ],
          ),
          
        ],
      ),
    );
  }
}
