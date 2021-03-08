import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CommonQuestionsPage extends StatefulWidget {
  CommonQuestionsPage({Key key}) : super(key: key);

  @override
  _CommonQuestionsPageState createState() => _CommonQuestionsPageState();
}

class _CommonQuestionsPageState extends State<CommonQuestionsPage> {
  final Color kingsBlue = HexColor('#0a2d50');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Common Questions",
            style: TextStyle(
                fontFamily: "MontserratRegular", fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: kingsBlue,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExpansionTile(
              title: Text("When will this bloody lockdown end GODDAMN IT?!!"),
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text("Keep guessing my child."),
                ]),
              ],
            ),
            ExpansionTile(
              title: Text("What can I do if I want to talk to someone?"),
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text("Keep guessing my child."),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
