import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class QuestionCard {
  final Color kingsBlue = HexColor('#0a2d50');

  Widget getQuestionCard(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontFamily: "MontserratBold",
          fontSize: 20,
        ),
      ),
      children: [
        SizedBox(
          height: 10,
        ),
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
        )
      ],
    );
  }
}
