import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tuple/tuple.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/no_internet.dart';

class WebpageManager extends StatefulWidget {
  final String pageName;
  WebpageManager({Key key, this.pageName}) : super(key: key);

  @override
  _WebpageManagerState createState() => _WebpageManagerState();
}

class _WebpageManagerState extends State<WebpageManager> {
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPearlGrey = HexColor("cdd7dc");

  final String TIER_TITLE = "Local Tier";
  final String TIER_URL =
      "https://www.gov.uk/guidance/national-lockdown-stay-at-home";
  final String HEATMAP_TITLE = "Covid-19 Heatmap UK";
  final String HEATMAP_URL = "https://www.covidlive.co.uk/";
  final String BOOKING_TITLE = "Covid-19 Test Booking";
  final String BOOKING_URL =
      "https://self-referral.test-for-coronavirus.service.gov.uk/antigen/essential-worker";
  final String QUICK_TEST_TITLE = "Rapid Lateral Flow Test";
  final String QUICK_TEST_URL =
      "https://www.gov.uk/find-covid-19-lateral-flow-test-site";

  Completer<WebViewController> _controller = Completer<WebViewController>();

  Tuple2<String, String> getWebpage() {
    switch (widget.pageName) {
      case "heatmap":
        return Tuple2(HEATMAP_TITLE, HEATMAP_URL);
        break;
      case "booking":
        return Tuple2(BOOKING_TITLE, BOOKING_URL);
        break;
      case "quick_test":
        return Tuple2(QUICK_TEST_TITLE, QUICK_TEST_URL);
        break;
      case "tier":
        return Tuple2(TIER_TITLE, TIER_URL);
        break;
    }
    return Tuple2("", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            getWebpage().item1,
            style: TextStyle(
                fontFamily: "MontserratRegular", fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: kingsBlue,
          actions: <Widget>[
            NavigationControls(_controller.future),
          ],
        ),
        body: FutureBuilder(
          future: Connectivity().checkConnectivity(),
          builder:
              (BuildContext context, AsyncSnapshot<ConnectivityResult> result) {
            if (result.data == ConnectivityResult.none) {
              return NoInternetPage();
            } else {
              return Container(
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: getWebpage().item2,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              );
            }
          },
        ));
  }
}

class NavigationControls extends StatelessWidget {
  final Future<WebViewController> _webViewControllerFuture;
  const NavigationControls(this._webViewControllerFuture);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: !webViewReady
                    ? null
                    : () async {
                        if (await controller.canGoBack()) {
                          controller.goBack();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("This is the first page."),
                          ));
                        }
                      }),
            IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: !webViewReady
                    ? null
                    : () async {
                        if (await controller.canGoForward()) {
                          controller.goForward();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("This is the last page."),
                          ));
                        }
                      }),
          ],
        );
      },
    );
  }
}
