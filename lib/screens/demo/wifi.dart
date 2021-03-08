import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/screens/demo/widgets/cards.dart';

class WifiScanPage extends StatefulWidget {
  final Function() notifyParent;
  const WifiScanPage({Key wifiList, @required this.notifyParent})
      : super(key: wifiList);

  @override
  _WifiScanPageState createState() => new _WifiScanPageState();
}

class _WifiScanPageState extends State<WifiScanPage> {
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

    void changeUserState(bool hasMatch) {
      user.hasBeenContacted = hasMatch;
    }

    CardsCreator cardsCreator =
        CardsCreator(changeUserState, widget.notifyParent);

    List<Widget> _widgetOptions =
        createBottomNavigatorBarWidgets(context, cardsCreator, user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WiFi List",
          style: TextStyle(
              fontFamily: "MontserratRegular", fontWeight: FontWeight.w600),
        ),
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
      BuildContext context, CardsCreator cardsCreator, String userId) {
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
