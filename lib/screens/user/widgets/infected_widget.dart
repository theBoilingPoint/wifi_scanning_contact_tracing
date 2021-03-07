import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scanning_flutter/screens/user/webpageManager.dart';

class InfectedWidgetLayout {
  Widget getWidgetWhenInfected(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You have been infected. Please self-isolate."),
          ElevatedButton(
            child: Text("Book a Test"),
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
