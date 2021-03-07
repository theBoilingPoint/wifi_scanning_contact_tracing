import 'package:flutter/material.dart';
import 'package:wifi_scanning_flutter/screens/user/webpageManager.dart';

class SymptomsWidgetLayout {
  Widget getWidgetWhenGotSymptoms(BuildContext context){
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You are likely to have COVID-19. Please self-isolate."),
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