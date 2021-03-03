import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/screens/authenticate/register.dart';
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

  //text field state
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        margin: EdgeInsets.all(20.0),
        alignment: Alignment.center, //align the list view to the center of the screen

        child: ListView(
          shrinkWrap: true,
          children: [
            Text("Welcome,",
            style: TextStyle(
              fontFamily: 'KingsCaslonDisplay',
              fontSize: 50,
              color: kingsBlue,
            ),),
            Text("please enter your credentials",
              style: TextStyle(
                  fontFamily: 'KingsCaslonText',
                  fontSize: 20,
                  color: kingsBlue
              ),
            ),
            SizedBox(height: 10.0,),
            Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,), //literally some space
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.account_circle)
                      ),
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password",
                          prefixIcon: Icon(Icons.lock)
                      ),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                  ],
                )
            ),
            Align(
              child: TextButton(
                onPressed: () async {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => Register()));
                },
                child: Text(
                  'REGISTER',
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ),
              alignment: Alignment.centerRight,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsPowderBlue),
              ),
              onPressed: () async {
                print("Email: $email Password: $password");
              },
              child: Text(
                'SIGN IN',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10.0,),
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
                'SIGN IN ANONYMOUSLY',
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
