import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/services/auth.dart';



class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Color kingsBackgroundColour = HexColor('#cdd7dc');
  final Color kingsBlue = HexColor('#0a2d50');
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kingsBackgroundColour,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kingsBlue,
        elevation: 0.0,
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: RaisedButton(
          child: Text('Sign in Anonymously'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result == null){
              print('Error Signing In');
            }
            else{
              print('Signed In');
              print(result.uid);
            }
          },
        ),
      ),
    );
  }
}
