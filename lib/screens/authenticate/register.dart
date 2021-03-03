import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/services/auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Color kingsBackgroundColour = HexColor('#cdd7dc');
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPowderBlue = HexColor("#8d9ebc");

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  RegExp emailRegex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  RegExp passwordRegex = new RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])$");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        margin: EdgeInsets.all(20.0),
        alignment: Alignment.center,

        child: ListView(
          shrinkWrap: true,
          children: [
            Text("Register",
                style: TextStyle(
                  fontFamily: 'KingsCaslonDisplay',
                  fontSize: 50,
                  color: kingsBlue,
                )),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,), //literally some space
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Please enter your email",
                          prefixIcon: Icon(Icons.account_circle)
                      ),
                      validator: (val) => !emailRegex.hasMatch(val) ? "Please enter a valid email." : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Please enter a password",
                          prefixIcon: Icon(Icons.lock)
                      ),
                      obscureText: true,
                      validator: (val) =>
                      !(val.length < 6 && passwordRegex.hasMatch(val)) ? "Your password should be at least 6 characters long and contain upper case, lower case, and digit." : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                  ],
                )
            ),
            SizedBox(height: 20.0,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kingsPowderBlue),
              ),
              onPressed: () async {
                if(_formKey.currentState.validate()) {
                  print("Email: $email Password: $password");
                  //dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                }
              },
              child: Text(
                'REGISTER',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )

      ),
    );
  }
}
