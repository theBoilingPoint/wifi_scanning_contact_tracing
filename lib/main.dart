import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/screens/wrapper.dart';
import 'package:wifi_scanning_flutter/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async => {
  WidgetsFlutterBinding.ensureInitialized(),
  await Firebase.initializeApp(),
  runApp(MyApp()),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          //CustomisedUser is the User class in the tutorial
          return StreamProvider<CustomisedUser>.value(
            value: AuthService().user,
            child: MaterialApp(
              home: Wrapper()
            ),
          );
        }
        );
  }
}




