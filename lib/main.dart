import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/services.dart';
import 'package:prj/models/customised_user.dart';
import 'package:prj/screens/wrapper.dart';
import 'package:prj/services/auth.dart';
import 'package:wifi/wifi.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomisedUser>.value(
      value: AuthService().user,
      builder: (context) {
        return Wrapper();
      },
      // child: MaterialApp(
      //     home: Wrapper()
      // ),
    );
  }
}


class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  Color kingsBlue = HexColor('#0a2d50');
  List<String> wifiSSID = [
    'asd',
    'xsc',
    '465',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internet Connection State'),
        centerTitle: true,
        backgroundColor: kingsBlue,
      ),
       body: Column(
         children: wifiSSID.map((e) => Text(e)).toList(),
       )
      //RaisedButton(
        //child: Text('click'),
        //onPressed: () =>{
          //setState(() {
              //_checkWiFiConnectivity();
            //}
          //)
        //},
      //),
    );
  }

  _checkWiFiConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      _showDialog(
          'Wifi Connected',
          'You are connected to Wifi.'
      );
    }
    else if(result == ConnectivityResult.mobile) {
      _showDialog(
          'Cellular Connected',
          'You are using your own mobile data. Please connect to a Wifi'
      );
    }
    else {
      _showDialog(
          'No internet connection',
          'Please connect to a Wifi'
      );
    }
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        }
    );
  }
}


