import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetPage extends StatefulWidget {
  NoInternetPage({Key key}) : super(key: key);

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
            "assets/lottie/no-connection.json",
            height: 300,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "No Internet Connection",
            style: TextStyle(fontFamily: "MontserratRegular", fontSize: 30),
          ),
        ],
      )
    );
  }
}