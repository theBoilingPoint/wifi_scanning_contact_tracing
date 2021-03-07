import 'package:flutter/material.dart';

class CommonQuestionsPage extends StatefulWidget {
  CommonQuestionsPage({Key key}) : super(key: key);

  @override
  _CommonQuestionsPageState createState() => _CommonQuestionsPageState();
}

class _CommonQuestionsPageState extends State<CommonQuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text("Common Questions"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ExpansionTile(
                title: Text("When will this bloody lockdown end GODDAMN IT!!"),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Keep guessing my child."),
                    ]
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}