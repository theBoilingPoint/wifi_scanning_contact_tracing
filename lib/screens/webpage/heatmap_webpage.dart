import 'dart:async';

import "package:flutter/material.dart";
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HeatMapWebView extends StatefulWidget {
  @override
  _HeatMapWebViewState createState() => _HeatMapWebViewState();
}

class _HeatMapWebViewState extends State<HeatMapWebView> {
  final Color kingsBlue = HexColor('#0a2d50');
  final Color kingsPearlGrey = HexColor("cdd7dc");

  Completer<WebViewController> _controller = Completer<WebViewController>();
  static const String HEATMAP_URL = "https://www.covidlive.co.uk/";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid-19 Heatmap UK'),
        centerTitle: true,
        backgroundColor: kingsBlue,
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: Container(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: "https://www.covidlive.co.uk/",
          onWebViewCreated: (WebViewController webViewController){
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  final Future<WebViewController> _webViewControllerFuture;
  const NavigationControls(this._webViewControllerFuture);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          final bool webViewReady = snapshot.connectionState == ConnectionState.done;
          final WebViewController controller = snapshot.data;
          return Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: !webViewReady ? null : () async {
                    if(await controller.canGoBack()){
                      controller.goBack();
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("This is the first page."),
                          ));
                    }
                  }),
              IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: !webViewReady ? null : () async {
                    if(await controller.canGoForward()){
                      controller.goForward();
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("This is the last page."),
                          ));
                    }
                  }),
            ],
          );
      },
    );
  }
}
