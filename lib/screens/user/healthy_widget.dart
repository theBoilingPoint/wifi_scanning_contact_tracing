import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/webpageManager.dart';

class HealthyWidgetLayout {
  final Color kingsBlue = HexColor('#0a2d50');

  Widget getWidgetWhenHealthy(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie/healthengine-generic-tickbox.json",
              height: 300, repeat: false),
          Text(
            "You are nice and well!",
            style: TextStyle(fontFamily: "MontserratRegular", fontSize: 30),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "If you are still worried, you can",
            style: TextStyle(
                fontFamily: "MontserratRegular",
                fontStyle: FontStyle.italic,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Text(
              "Book a Quick Test",
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
                            pageName: "quick_test",
                          )));
            },
          ),
        ],
      ),
    );
  }
}
