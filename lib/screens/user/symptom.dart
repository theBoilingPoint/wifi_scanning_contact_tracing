import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';

class SymptomsCheckPage extends StatefulWidget {
  final Function() notifyParent;
  SymptomsCheckPage({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _SymptomsCheckPageState createState() => _SymptomsCheckPageState();
}

class _SymptomsCheckPageState extends State<SymptomsCheckPage> {
  final Color kingsBlue = HexColor('#0a2d50');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Symptoms Check",
          style: TextStyle(
              fontFamily: "MontserratRegular", fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: kingsBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CheckboxListTile(
            title: Text(
              "High Temperature",
              style: TextStyle(
                  fontFamily: "MontserratBold",
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "this means you feel hot to touch on your chest or back (you do not need to measure your temperature)",
              style: TextStyle(
                  fontFamily: "MontserratRegular",
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            value: user.gotTemperature,
            onChanged: (bool val) {
              setState(() {
                user.gotTemperature = val;
                widget.notifyParent();
              });
            },
          ),
          CheckboxListTile(
            title: Text(
              "New, Continuous Cough",
              style: TextStyle(
                  fontFamily: "MontserratBold",
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "this means coughing a lot for more than an hour, or 3 or more coughing episodes in 24 hours (if you usually have a cough, it may be worse than usual)",
              style: TextStyle(
                  fontFamily: "MontserratRegular",
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            value: user.gotCough,
            onChanged: (bool val) {
              setState(() {
                user.gotCough = val;
                widget.notifyParent();
              });
            },
          ),
          CheckboxListTile(
            title: Text(
              "Loss or Change to Sense of Smell or Taste",
              style: TextStyle(
                  fontFamily: "MontserratBold",
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "this means you've noticed you cannot smell or taste anything, or things smell or taste different to normal",
              style: TextStyle(
                  fontFamily: "MontserratRegular",
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            value: user.gotSenseLoss,
            onChanged: (bool val) {
              setState(() {
                user.gotSenseLoss = val;
                widget.notifyParent();
              });
            },
          ),
        ],
      ),
    );
  }
}
