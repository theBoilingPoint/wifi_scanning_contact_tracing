import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/screens/user/user.dart';
import 'package:wifi_scanning_flutter/services/wifi.dart';

class Home extends StatelessWidget {
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPearlGrey = HexColor("cdd7dc");
  
  final CameraPosition currentLocation = CameraPosition(target: LatLng(52.029220, -2.101940));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WiFi Scanning'),
        centerTitle: true,
        backgroundColor: kingsBlue,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person, color: kingsPearlGrey,),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (context) => User()));
          })
        ],
      ),
      // body: Center(
      //   child: new MyHomePage(),
      // ),
      body: GoogleMap(
        initialCameraPosition: currentLocation,
        mapType: MapType.normal,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.network_wifi),
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => MyHomePage()));
          },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


