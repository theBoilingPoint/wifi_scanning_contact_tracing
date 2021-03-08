import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/question_card.dart';

class CommonQuestionsPage extends StatefulWidget {
  CommonQuestionsPage({Key key}) : super(key: key);

  @override
  _CommonQuestionsPageState createState() => _CommonQuestionsPageState();
}

class _CommonQuestionsPageState extends State<CommonQuestionsPage> {
  final Color kingsBlue = HexColor('#0a2d50');
  QuestionCard questionCard = QuestionCard();

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
            questionCard.getQuestionCard(
                "When will the lockdown end?", "Keep guessing my child."),
            questionCard.getQuestionCard(
                "What can I do if I want to talk to someone?",
                "Keep guessing my child."),
          ],
        ),
      ),
    );
  }
}
