import 'package:flutter/material.dart';

class NoInternetPage extends StatefulWidget {
  NoInternetPage({Key key}) : super(key: key);

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("You are not connected to the internet."),
    );
  }
}