import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/screens/demo/widgets/cards.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key wifiList}) : super(key: wifiList);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CardsCreator cardsCreator = CardsCreator();
  int bottomNavigationBarIdx = 0;
  bool hasMatch;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      bottomNavigationBarIdx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);
    final Color kingsBlue = HexColor('#0a2d50');
    List<Widget> _widgetOptions =
        createBottomNavigatorBarWidgets(context, user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text("WiFi List"),
        centerTitle: true,
        backgroundColor: kingsBlue,
      ),
      body: Center(
        child: _widgetOptions.elementAt(bottomNavigationBarIdx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.signal_wifi_4_bar_lock), label: "Offline Phase"),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload), label: "Online Phase"),
        ],
        currentIndex: bottomNavigationBarIdx,
        onTap: _onItemTapped,
      ),
    );
  }

  List<Widget> createBottomNavigatorBarWidgets(
      BuildContext context, String userId) {
    List<Widget> widgets = [
      Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: 600,
              viewportFraction: 0.8,
              initialPage: 0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            ),
            items: cardsCreator.createOfflineStepCards(context, userId),
          ),
        ],
      )),
      Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: 600,
              viewportFraction: 0.8,
              initialPage: 0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            ),
            items: cardsCreator.createOnlineStepCards(context, userId),
          ),
        ],
      )),
    ];
    return widgets;
  }
}
