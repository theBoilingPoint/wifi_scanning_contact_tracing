import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_scanning_flutter/services/auth.dart';



class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Color kingsBackgroundColour = HexColor('#cdd7dc');
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPowderBlue = HexColor("#8d9ebc");

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        margin: EdgeInsets.all(20.0),
        alignment: Alignment.topCenter, //align the list view to the center of the screen
        child: ListView(
          shrinkWrap: true,
          children: [
            Lottie.asset(
              "assets/lottie/covid.json",
            ),
            SizedBox(height: 50.0,),
            Text("Welcome,",
            style: TextStyle(
              fontFamily: 'MontserratBold',
              fontSize: 50,
              color: kingsBlue,
            ),),
            Text("this is a contact tracing app prototype",
              style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  fontSize: 20,
                  color: kingsBlue
              ),
            ),
            SizedBox(height: 10.0,),
            Align(
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: 25.0,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsPowderBlue),
              ),
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
              child: Text(
                'CONTINUE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
