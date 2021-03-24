import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_scanning_flutter/screens/demo/db_operations.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi_matching.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/wifi_background_manager.dart';
import 'package:wifi_scanning_flutter/services/user_preference.dart';
import 'package:loading_animations/loading_animations.dart';

class WiFiBackgroundActivity extends StatefulWidget {
  final Function() notifyParent;
  final WiFiBackgroundActivityManager wiFiBackgroundActivityManager;
  final bool isScanning;
  WiFiBackgroundActivity({
    Key key, 
    @required this.notifyParent, 
    @required this.isScanning, 
    @required this.wiFiBackgroundActivityManager
  }) : super(key: key);

  @override
  _WiFiBackgroundActivityState createState() => _WiFiBackgroundActivityState();
}

class _WiFiBackgroundActivityState extends State<WiFiBackgroundActivity> {
  DatabaseOperations databaseOperations = DatabaseOperations();
  WifiMatching matcher = new WifiMatching();
  final Color kingsBlue = HexColor('#0a2d50');
  bool isRunning;

  @override 
  void initState() { 
    super.initState();
    isRunning = widget.isScanning;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WiFi Background",
          style: TextStyle(
            fontFamily: "MontserratRegular", fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        backgroundColor: kingsBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow), 
            onPressed: () async {
              setState(() {
                isRunning = true;
              });
              await UserPreference.setWiFiBackgroundActivityState(isRunning);
              await widget.wiFiBackgroundActivityManager.
                startTimer();
              widget.notifyParent();
            }
          ),
          IconButton(
            icon: Icon(Icons.stop), 
            onPressed: () async {
              setState(() {
                isRunning = false;
              });  
              await UserPreference.setWiFiBackgroundActivityState(isRunning);
              widget.wiFiBackgroundActivityManager.cancelTimer();
              widget.notifyParent();
            }
          ),
        ],
      ),
      body: mainPage(),
      floatingActionButton: Visibility(
        visible: !isRunning,
        child: FloatingActionButton.extended(
          icon: Icon(Icons.fact_check),
          backgroundColor: kingsBlue,
          label: Text("Check Out Matching Steps"),
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => WifiScanPage(notifyParent: widget.notifyParent)
              )
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget mainPage() {
    if(isRunning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingBouncingGrid.square(
              backgroundColor: kingsBlue,
              size: 100,
            ),
            SizedBox(height: 20,),
            Text(
              "The WiFi matching is running",
              style: TextStyle(
                fontFamily: "MontserratRegular", fontSize: 20
              ),
            ),
          ],
        )
      );
    }
    else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie/stop.json",
              height: 200,
              repeat: false,
            ),
            SizedBox(height: 20,),
            Text(
              "The WiFi matching is not running",
              style: TextStyle(
                fontFamily: "MontserratRegular", fontSize: 20
              ),
            ),
          ],
        ),
      );
    }
  }
}