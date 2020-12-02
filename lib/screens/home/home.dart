import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Home extends StatelessWidget {
  final Color kingsBlue = HexColor('#0a2d50');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WiFi Scanning'),
        centerTitle: true,
        backgroundColor: kingsBlue,
      ),
      body: Center(
        child: Text('I actually want a WiFi list here'),
      ),
    );
  }

}