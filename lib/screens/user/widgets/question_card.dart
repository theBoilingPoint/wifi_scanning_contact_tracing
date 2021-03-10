import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class QuestionCard {
  //UI
  final Color kingsBlue = HexColor('#0a2d50');
  final GlobalKey expansionTileKey = GlobalKey();

  final String question;
  final String answer;

  QuestionCard({this.question, this.answer});

  void _scrollToSelectedContent({GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  Widget getQuestionCard() {
    return ExpansionTile(
      key: expansionTileKey,
      onExpansionChanged: (value) {
        if (value) {
              _scrollToSelectedContent(expansionTileKey: expansionTileKey);
         }
       },
      title: Text(
        question,
        style: TextStyle(
          fontFamily: "MontserratBold",
          fontSize: 18,
        ),
      ),
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            answer,
            style: TextStyle(
              fontFamily: "MontserratRegular",
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
