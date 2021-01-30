import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/screens/user/setting.dart';

class User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserHomePage();
  }
}

class UserHomePage extends State<User> {
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPearlGrey = HexColor("cdd7dc");

  @override
  void initState(){
   super.initState();
  }

  @override
  Widget build(BuildContext context){
    final user = Provider.of<CustomisedUser>(context);
    void toggleInfectionState(){
      setState(() {
        user.infectionState = !user.infectionState;
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