import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_scanning_flutter/screens/user/webpageManager.dart';

class SymptomsWidgetLayout {
  final Color kingsBlue = HexColor('#0a2d50');

  Widget getWidgetWhenGotSymptoms(BuildContext context) {
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
          Text(
            "you can",
            style: TextStyle(
                fontFamily: "MontserratRegular",
                fontStyle: FontStyle.italic,
                fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
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
        ],
      ),
    );
  }
}
