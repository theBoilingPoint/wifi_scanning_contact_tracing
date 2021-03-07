import 'package:flutter/material.dart';
import 'package:wifi_scanning_flutter/screens/user/webpageManager.dart';

class HealthyWidgetLayout {
  Widget getWidgetWhenHealthy(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You are nice and well."),
          ElevatedButton(
            child: Text("Book a Quick Test"),
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
