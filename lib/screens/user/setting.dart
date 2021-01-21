import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/services/auth.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserSetting();
  }
}

class UserSetting extends State<Setting> {
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPearlGrey = HexColor("cdd7dc");
  final Color kingsSlateGrey = HexColor("5a6469");
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: kingsBlue,
      ),
      body: Center(
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kingsSlateGrey),
          ),
          child: Text(
              "SIGN OUT",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            await _auth.signOut();
            //Go back to sign in page by removing the top elements of the page stack
            Navigator.popUntil(context, ModalRoute.withName("/"));
          },
        ),
      ),
    );
  }

}