import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/screens/user/setting.dart';

import '../../user_data.dart';

class User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserHomePage();
  }
}

class UserHomePage extends State<User> {
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPearlGrey = HexColor("cdd7dc");
  //get a database object
  UserData userData = UserData();

  @override
  void initState(){
   super.initState();
   //initialise the user database
   //there will only be 1 database for the app
   userData.initialiseDatabase().then((value) {
     print("User database is initialised.");
   });
  }

  @override
  Widget build(BuildContext context){
    final user = Provider.of<CustomisedUser>(context);
    void toggleInfectionState(){
      setState(() {
        user.infectionState = !user.infectionState;
        userData.insertUserInfo(user);
        print(userData);
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Personal Page"),
          backgroundColor: kingsBlue,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings, color: kingsPearlGrey,),
                onPressed: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => Setting()));
                })
          ]
        ),
      body: Center(
        child: Text('The current user infection state is: ${user.infectionState}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.priority_high),
        onPressed: () {
          toggleInfectionState();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}