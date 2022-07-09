import 'dart:io';
import 'package:flutter/material.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermofusePage extends StatefulWidget {
  @override
  TermofusePageState createState() => TermofusePageState();
}

class TermofusePageState extends State<TermofusePage> {
  bool isLoading = true;
  final _key = UniqueKey();
  var url = "https://pages.flycricket.io/passify-0/terms.html";
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Terms of Use"),
      body: Center(
        child: Stack(
          children: [
            Stack(
              children: <Widget>[
                WebView(
                  key: _key,
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
