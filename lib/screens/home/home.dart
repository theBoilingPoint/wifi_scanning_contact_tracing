import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:wifi_scanning_flutter/screens/user/user.dart';
import 'package:wifi_scanning_flutter/screens/demo/wifi.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPearlGrey = HexColor("cdd7dc");

  Location location = new Location();

  Set<Marker> markers = HashSet<Marker>();
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;

    setState(() {
      markers.add(
        Marker(
            markerId: MarkerId("Home"),
          position: LatLng(52.029220, -2.101940),
          infoWindow: InfoWindow(
            title: "My Home",
          )
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var coordinate = getCurrentLocation();
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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(52.029220, -2.101940),
          zoom: 20
        ),
        markers: markers,
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

  Future<LocationData> getCurrentLocation() async {
    return await location.getLocation();
  }
}


