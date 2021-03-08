import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_scanning_flutter/screens/user/webpageManager.dart';

class ContactWidgetLayout {
  final Color kingsBlue = HexColor('#0a2d50');

  Widget getWidgetWhenContacted(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/lottie/covid-contact.json",
            height: 300,
          ),
          Text(
            "You have been contacted",
            style: TextStyle(fontFamily: "MontserratRegular", fontSize: 27),
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
