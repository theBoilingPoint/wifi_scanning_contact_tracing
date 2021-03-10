import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         body: Center(
            child: Text(
              "Loading...",
              style: TextStyle(
                fontFamily: "MontserratBold",
                fontSize: 30
              ),
            )
         ),
       ),
    );
  }
}