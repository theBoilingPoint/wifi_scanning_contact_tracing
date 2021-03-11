/*
Since flutter dev is currently migrating the platform, firebase messaging is
incompatible with plugins flutter_local_notifications: ^4.0.1+2 and 
flutter_local_notifications_platform_interface: ^2.0.0+1. So background push 
notification can't be implemented successfully. 
Hopefully flutter dev can debug this soon.
*/


import 'package:flutter/material.dart';

class MessageHandler extends StatefulWidget {
  MessageHandler({Key key}) : super(key: key);

  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(),
    );
  }
}
