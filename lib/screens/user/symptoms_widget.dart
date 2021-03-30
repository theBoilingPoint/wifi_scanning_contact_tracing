import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:wifi_scanning_flutter/services/user_preference.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/webpageManager.dart';

class SymptomsWidgetLayout {
  final Color kingsBlue = HexColor('#0a2d50');
  final Function refreshMainPage;

  SymptomsWidgetLayout(this.refreshMainPage);

  Widget getWidgetWhenGotSymptoms(BuildContext context, Duration duration) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/lottie/corona-virus-sick.json",
            height: 300,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "You are likely to be infected",
            style: TextStyle(fontFamily: "MontserratRegular", fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please self-isolate for",
            style: TextStyle(
                fontFamily: "MontserratRegular",
                fontStyle: FontStyle.italic,
                fontSize: 23),
          ),
          SlideCountdownClock(
            duration: duration,
            slideDirection: SlideDirection.Down,
            separator: ":",
            textStyle: TextStyle(
              fontFamily: "MontserratRegular",
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            onDone: () async {
              await UserPreference.setHasCough(false);
              await UserPreference.setHasFever(false);
              await UserPreference.setHasSenseLoss(false);
              refreshMainPage();
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
